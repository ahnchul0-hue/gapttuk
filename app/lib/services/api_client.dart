import 'package:dio/dio.dart';

import '../config/api_endpoints.dart';
import '../config/constants.dart';
import 'token_storage.dart';

/// Dio HTTP 클라이언트 + JWT 인터셉터.
class ApiClient {
  late final Dio dio;
  final TokenStorage _tokenStorage;

  /// 세션 만료 시 호출되는 콜백 (로그인 화면으로 리다이렉트 등).
  static void Function()? onSessionExpired;

  ApiClient({required TokenStorage tokenStorage})
      : _tokenStorage = tokenStorage {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.httpTimeout,
        receiveTimeout: AppConstants.httpTimeout,
        sendTimeout: AppConstants.httpTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Encoding': 'gzip',
        },
      ),
    );
    dio.interceptors.add(_AuthInterceptor(this));
  }

  /// 토큰 갱신 (refresh_token → 새 access_token + refresh_token).
  Future<bool> refreshTokens() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      // 인터셉터를 우회하여 직접 요청 (무한 루프 방지)
      final response = await Dio(BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.httpTimeout,
        receiveTimeout: AppConstants.httpTimeout,
      )).post(
        ApiEndpoints.authRefresh,
        data: {'refresh_token': refreshToken},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      await _tokenStorage.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
      return true;
    } on DioException {
      await _tokenStorage.clearTokens();
      return false;
    }
  }
}

/// JWT 자동 주입 + 401 시 토큰 갱신 재시도.
class _AuthInterceptor extends Interceptor {
  final ApiClient _client;

  /// 토큰 갱신 중복 방지 — 동시에 여러 요청이 401을 받아도 한 번만 갱신.
  Future<bool>? _refreshFuture;

  _AuthInterceptor(this._client);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _client._tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // 이미 갱신 중이면 기존 Future를 재사용 (race condition 방지).
        // whenComplete로 Future 완료 후 정확히 한 번만 정리.
        final refresh = _refreshFuture ??= _client
            .refreshTokens()
            .whenComplete(() => _refreshFuture = null);
        final refreshed = await refresh;

        if (refreshed) {
          // 갱신 성공 → 원래 요청 재시도
          final token = await _client._tokenStorage.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          try {
            final response = await _client.dio.fetch(err.requestOptions);
            return handler.resolve(response);
          } on DioException catch (e) {
            return handler.next(e);
          }
        }

        // 갱신 실패 → 세션 만료 처리
        await _client._tokenStorage.clearTokens();
        ApiClient.onSessionExpired?.call();
      } catch (_) {
        await _client._tokenStorage.clearTokens();
        ApiClient.onSessionExpired?.call();
      }
    }
    handler.next(err);
  }
}
