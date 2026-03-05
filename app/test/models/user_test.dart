import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/models/user.dart';

void main() {
  group('User', () {
    test('fromJson — 전체 필드', () {
      final json = {
        'id': 1,
        'email': 'test@example.com',
        'nickname': '민지',
        'profile_image_url': 'https://cdn.example.com/photo.jpg',
        'referral_code': 'ABC123',
      };

      final user = User.fromJson(json);

      expect(user.id, 1);
      expect(user.email, 'test@example.com');
      expect(user.nickname, '민지');
      expect(user.profileImageUrl, 'https://cdn.example.com/photo.jpg');
      expect(user.referralCode, 'ABC123');
    });

    test('fromJson — 최소 필드', () {
      final user = User.fromJson({'id': 2});

      expect(user.id, 2);
      expect(user.email, isNull);
      expect(user.nickname, isNull);
    });
  });

  group('AuthTokens', () {
    test('fromJson', () {
      final json = {
        'access_token': 'jwt.token.here',
        'refresh_token': 'a' * 64,
        'expires_in': 300,
      };

      final tokens = AuthTokens.fromJson(json);

      expect(tokens.accessToken, 'jwt.token.here');
      expect(tokens.refreshToken.length, 64);
      expect(tokens.expiresIn, 300);
    });

    test('expiresIn 기본값 300', () {
      final json = {
        'access_token': 'tok',
        'refresh_token': 'ref',
      };
      expect(AuthTokens.fromJson(json).expiresIn, 300);
    });
  });

  group('AuthResponse', () {
    test('fromJson — 중첩 객체', () {
      final json = {
        'user': {
          'id': 1,
          'email': 'user@test.com',
          'nickname': '테스터',
        },
        'tokens': {
          'access_token': 'at',
          'refresh_token': 'rt',
          'expires_in': 600,
        },
        'is_new_user': true,
      };

      final auth = AuthResponse.fromJson(json);

      expect(auth.user.id, 1);
      expect(auth.user.email, 'user@test.com');
      expect(auth.tokens.accessToken, 'at');
      expect(auth.tokens.expiresIn, 600);
      expect(auth.isNewUser, true);
    });

    test('isNewUser 기본값 false', () {
      final json = {
        'user': {'id': 1},
        'tokens': {'access_token': 'a', 'refresh_token': 'r'},
      };
      expect(AuthResponse.fromJson(json).isNewUser, false);
    });
  });
}
