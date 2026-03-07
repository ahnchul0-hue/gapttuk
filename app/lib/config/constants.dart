/// 앱 전역 상수.
abstract final class AppConstants {
  // --- API ---
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  // --- 캐시 ---
  static const Duration httpTimeout = Duration(seconds: 15);

  // --- 페이지네이션 ---
  static const int defaultPageSize = 20;

  // --- 가격 포맷 ---
  static const String currencySymbol = '₩';

  // --- 보상 화폐 ---
  static const String rewardUnit = '¢'; // 센트

  // --- 저장소 키 ---
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  // --- 앱 정보 ---
  static const String appVersion = '0.1.0';
  static const String termsUrl = 'https://gapttuk.com/terms';
  static const String privacyUrl = 'https://gapttuk.com/privacy';

  // --- 소셜 로그인 ---
  static const String kakaoNativeAppKey =
      String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
  static const String kakaoAppId =
      String.fromEnvironment('KAKAO_APP_ID');
  static const String googleClientId =
      String.fromEnvironment('GOOGLE_CLIENT_ID');
}
