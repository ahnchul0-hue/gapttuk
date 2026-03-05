import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 서버 UserDto — /auth/me 및 로그인 응답에 포함
@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    String? email,
    String? nickname,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    @JsonKey(name: 'referral_code') String? referralCode,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// 토큰 쌍 — access_token(JWT) + refresh_token(64자 hex) + expires_in(초)
@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_in') @Default(300) int expiresIn,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);
}

/// 로그인 응답 — { user, tokens, is_new_user }
@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required User user,
    required AuthTokens tokens,
    @JsonKey(name: 'is_new_user') @Default(false) bool isNewUser,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
