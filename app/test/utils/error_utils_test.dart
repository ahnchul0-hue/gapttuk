import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gapttuk_app/utils/error_utils.dart';

void main() {
  group('friendlyErrorMessage', () {
    test('connectionTimeout → 서버 응답 느림', () {
      final error = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(),
      );
      expect(friendlyErrorMessage(error), contains('서버 응답이 느립니다'));
    });

    test('sendTimeout → 서버 응답 느림', () {
      final error = DioException(
        type: DioExceptionType.sendTimeout,
        requestOptions: RequestOptions(),
      );
      expect(friendlyErrorMessage(error), contains('서버 응답이 느립니다'));
    });

    test('receiveTimeout → 서버 응답 느림', () {
      final error = DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(),
      );
      expect(friendlyErrorMessage(error), contains('서버 응답이 느립니다'));
    });

    test('connectionError → 인터넷 연결 확인', () {
      final error = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(),
      );
      expect(friendlyErrorMessage(error), contains('인터넷 연결'));
    });

    test('badResponse 401 → 인증 실패', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(),
        ),
      );
      expect(friendlyErrorMessage(error), contains('인증'));
    });

    test('badResponse 429 → 요청 과다', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 429,
          requestOptions: RequestOptions(),
        ),
      );
      expect(friendlyErrorMessage(error), contains('요청이 너무 많습니다'));
    });

    test('badResponse 500 → 서버 오류', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(),
        ),
      );
      expect(friendlyErrorMessage(error), contains('서버 오류'));
    });

    test('badResponse 503 → 서버 오류', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 503,
          requestOptions: RequestOptions(),
        ),
      );
      expect(friendlyErrorMessage(error), contains('서버 오류'));
    });

    test('badResponse 400 + 서버 메시지 → 서버 메시지 반환', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 400,
          data: {
            'ok': false,
            'error': {'code': 'VALIDATION_001', 'message': '잘못된 URL 형식입니다.'},
          },
          requestOptions: RequestOptions(),
        ),
      );
      expect(friendlyErrorMessage(error), '잘못된 URL 형식입니다.');
    });

    test('badResponse 400 + 메시지 없음 → 처리 불가', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 400,
          data: {'error': 'bad_request'},
          requestOptions: RequestOptions(),
        ),
      );
      expect(friendlyErrorMessage(error), contains('처리할 수 없습니다'));
    });

    test('unknown 타입 → 알 수 없는 오류', () {
      final error = DioException(
        type: DioExceptionType.unknown,
        requestOptions: RequestOptions(),
      );
      expect(friendlyErrorMessage(error), contains('알 수 없는 오류'));
    });

    test('일반 Exception → 오류 발생', () {
      expect(friendlyErrorMessage(Exception('boom')), contains('오류가 발생'));
    });

    test('문자열 에러', () {
      expect(friendlyErrorMessage('something failed'), contains('오류가 발생'));
    });
  });

  group('formatPrice', () {
    test('1000 미만', () {
      expect(formatPrice(999), '₩999');
    });

    test('1000 이상 — 쉼표 포맷', () {
      expect(formatPrice(1000), '₩1,000');
    });

    test('대형 금액', () {
      expect(formatPrice(1234567), '₩1,234,567');
    });

    test('0원', () {
      expect(formatPrice(0), '₩0');
    });
  });
}
