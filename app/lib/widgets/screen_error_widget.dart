import 'package:flutter/material.dart';
import '../config/theme.dart';

/// 화면 로드 실패 시 표시하는 공통 에러 위젯.
/// alert / favorites / notification 등 전체 화면 에러 상태에 사용.
class ScreenErrorWidget extends StatelessWidget {
  const ScreenErrorWidget({
    super.key,
    required this.message,
    required this.detail,
    required this.onRetry,
  });

  /// 주요 에러 메시지 (굵은 텍스트)
  final String message;

  /// 상세 에러 설명 (작은 텍스트)
  final String detail;

  /// 다시 시도 버튼 콜백
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: appColors.error),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            style: TextStyle(color: appColors.neutral, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
