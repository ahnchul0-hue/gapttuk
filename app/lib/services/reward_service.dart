import 'api_client.dart';

/// 일일 룰렛 결과.
class CheckinResult {
  final int rewardAmount;
  final bool alreadyCheckedIn;

  const CheckinResult({
    required this.rewardAmount,
    required this.alreadyCheckedIn,
  });

  factory CheckinResult.fromJson(Map<String, dynamic> json) => CheckinResult(
        rewardAmount: json['reward_amount'] as int? ?? 0,
        alreadyCheckedIn: json['already_checked_in'] as bool? ?? false,
      );
}

/// 센트 잔액 정보.
class PointsInfo {
  final int balance;
  final int totalEarned;
  final int totalSpent;

  const PointsInfo({
    required this.balance,
    required this.totalEarned,
    required this.totalSpent,
  });

  factory PointsInfo.fromJson(Map<String, dynamic> json) => PointsInfo(
        balance: json['balance'] as int? ?? 0,
        totalEarned: json['total_earned'] as int? ?? 0,
        totalSpent: json['total_spent'] as int? ?? 0,
      );
}

/// 보상 API 호출 서비스.
class RewardService {
  final ApiClient _api;

  RewardService({required ApiClient api}) : _api = api;

  /// POST /api/v1/rewards/checkin — 오늘의 출석 룰렛 실행.
  ///
  /// 하루 1회 제한. 이미 출석한 경우 [CheckinResult.alreadyCheckedIn] = true.
  Future<CheckinResult> checkin() async {
    final response = await _api.dio.post('/api/v1/rewards/checkin');
    final data = response.data['data'] as Map<String, dynamic>;
    return CheckinResult.fromJson(data);
  }

  /// GET /api/v1/rewards/points — 센트 잔액 조회.
  Future<PointsInfo> getPoints() async {
    final response = await _api.dio.get('/api/v1/rewards/points');
    final data = response.data['data'] as Map<String, dynamic>;
    return PointsInfo.fromJson(data);
  }
}
