import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/alert.dart';

/// 알림 유형을 사람이 읽을 수 있는 한글 레이블로 변환.
///
/// favorites_screen, alert_screen 양쪽에서 공통으로 사용한다.
String alertTypeLabel(AlertType type) => switch (type) {
      AlertType.targetPrice => '목표 가격',
      AlertType.belowAverage => '평균 이하',
      AlertType.nearLowest => '최저가 근접',
      AlertType.allTimeLow => '최저가 갱신',
    };

/// 알림 유형에 대응하는 시맨틱 색상 반환.
Color alertTypeColor(AlertType type, AppColors appColors) => switch (type) {
      AlertType.targetPrice => appColors.info,
      AlertType.belowAverage => appColors.success,
      AlertType.nearLowest => appColors.warning,
      AlertType.allTimeLow => appColors.error,
    };

/// 알림 유형을 색상 뱃지로 표시하는 위젯.
///
/// FavoritesScreen의 상품 카드 상단에 오버레이로 사용된다.
class AlertTypeBadge extends StatelessWidget {
  final AlertType alertType;

  const AlertTypeBadge({super.key, required this.alertType});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final label = alertTypeLabel(alertType);
    final color = alertTypeColor(alertType, appColors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(230),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
