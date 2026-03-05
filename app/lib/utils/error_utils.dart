import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// DioException을 사용자 친화적 메시지로 변환.
String friendlyErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '서버 응답이 느립니다. 잠시 후 다시 시도해 주세요.';
      case DioExceptionType.connectionError:
        return '인터넷 연결을 확인해 주세요.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) return '인증에 실패했습니다. 다시 로그인해 주세요.';
        if (statusCode == 429) return '요청이 너무 많습니다. 잠시 후 다시 시도해 주세요.';
        if (statusCode != null && statusCode >= 500) {
          return '서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.';
        }
        // 서버 에러 메시지가 있으면 사용
        // 서버 응답 구조: { "ok": false, "error": { "code": "...", "message": "..." } }
        final data = error.response?.data;
        if (data is Map) {
          final errorObj = data['error'];
          if (errorObj is Map && errorObj['message'] is String) {
            return errorObj['message'] as String;
          }
        }
        return '요청을 처리할 수 없습니다.';
      default:
        return '알 수 없는 오류가 발생했습니다.';
    }
  }
  return '오류가 발생했습니다: $error';
}

/// SnackBar로 에러 메시지를 표시하는 헬퍼.
void showErrorSnackBar(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(friendlyErrorMessage(error))),
  );
}

/// 한국 원화 가격 포맷 (₩1,234).
final _priceFormatter = NumberFormat('#,###', 'ko_KR');

/// 정수 가격을 ₩1,234 형식으로 포맷.
String formatPrice(int price) => '₩${_priceFormatter.format(price)}';
