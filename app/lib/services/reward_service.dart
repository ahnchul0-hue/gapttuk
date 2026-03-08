import '../config/api_endpoints.dart';
import 'api_client.dart';

/// 일일 룰렛 결과.
class CheckinResult {
  final int rewardAmount;
  final bool alreadyCheckedIn;
  final int newBalance;

  const CheckinResult({
    required this.rewardAmount,
    required this.alreadyCheckedIn,
    required this.newBalance,
  });

  factory CheckinResult.fromJson(Map<String, dynamic> json) => CheckinResult(
        rewardAmount: json['reward_amount'] as int? ?? 0,
        alreadyCheckedIn: json['already_checked_in'] as bool? ?? false,
        newBalance: json['new_balance'] as int? ?? 0,
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
    final response = await _api.dio.post(ApiEndpoints.rewardsCheckin);
    final data = response.data['data'] as Map<String, dynamic>;
    return CheckinResult.fromJson(data);
  }

  /// GET /api/v1/rewards/points — 센트 잔액 조회.
  Future<PointsInfo> getPoints() async {
    final response = await _api.dio.get(ApiEndpoints.rewardsPoints);
    final data = response.data['data'] as Map<String, dynamic>;
    return PointsInfo.fromJson(data);
  }

  /// GET /api/v1/rewards/referrals — 리퍼럴 현황 조회.
  Future<ReferralStats> getReferrals() async {
    final response = await _api.dio.get(ApiEndpoints.rewardsReferrals);
    return ReferralStats.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  /// GET /api/v1/rewards/history — 포인트 내역 조회 (커서 페이지네이션).
  Future<({List<PointHistoryItem> items, bool hasMore})> getHistory({
    int? cursor,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'limit': limit};
    if (cursor != null) params['cursor'] = cursor;
    final response = await _api.dio.get(
      ApiEndpoints.rewardsHistory,
      queryParameters: params,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final items = (data['items'] as List)
        .map((e) => PointHistoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return (items: items, hasMore: data['has_more'] as bool);
  }
}

/// 리퍼럴 현황 통계.
class ReferralStats {
  final String? referralCode;
  final int totalReferred;
  final int totalEarnedCents;
  final List<ReferralItem> referrals;

  const ReferralStats({
    required this.referralCode,
    required this.totalReferred,
    required this.totalEarnedCents,
    required this.referrals,
  });

  factory ReferralStats.fromJson(Map<String, dynamic> json) => ReferralStats(
        referralCode: json['referral_code'] as String?,
        totalReferred: json['total_referred'] as int,
        totalEarnedCents: json['total_earned_cents'] as int,
        referrals: (json['referrals'] as List)
            .map((e) => ReferralItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// 리퍼럴 항목.
class ReferralItem {
  final String? referredNickname;
  final int rewardStage;
  final int earnedCents;
  final String createdAt;

  const ReferralItem({
    required this.referredNickname,
    required this.rewardStage,
    required this.earnedCents,
    required this.createdAt,
  });

  factory ReferralItem.fromJson(Map<String, dynamic> json) => ReferralItem(
        referredNickname: json['referred_nickname'] as String?,
        rewardStage: json['reward_stage'] as int,
        earnedCents: json['earned_cents'] as int,
        createdAt: json['created_at'] as String,
      );
}

/// 포인트 내역 항목.
class PointHistoryItem {
  final int id;
  final int amount;
  final String transactionType;
  final String? description;
  final String createdAt;

  const PointHistoryItem({
    required this.id,
    required this.amount,
    required this.transactionType,
    this.description,
    required this.createdAt,
  });

  factory PointHistoryItem.fromJson(Map<String, dynamic> json) =>
      PointHistoryItem(
        id: json['id'] as int,
        amount: json['amount'] as int,
        transactionType: json['transaction_type'] as String,
        description: json['description'] as String?,
        createdAt: json['created_at'] as String,
      );
}
