import 'dart:async';

import 'package:gapttuk_app/services/reward_service.dart';

/// RewardService fake (implements) — ApiClient/TokenStorage 불필요.
///
/// [points]: getPoints()가 반환할 데이터.
/// [history]: getHistory()가 반환할 데이터.
/// [error]: non-null이면 모든 호출이 예외를 던진다.
/// [slow]: true이면 getHistory()가 영원히 pending (로딩 상태 테스트용).
class FakeRewardService implements RewardService {
  final PointsInfo _points;
  final ({List<PointHistoryItem> items, bool hasMore}) _history;
  final Exception? _error;
  final bool _slow;

  FakeRewardService({
    PointsInfo? points,
    ({List<PointHistoryItem> items, bool hasMore})? history,
    Exception? error,
    bool slow = false,
  })  : _points = points ??
            const PointsInfo(balance: 5, totalEarned: 10, totalSpent: 5),
        _history = history ?? (items: [], hasMore: false),
        _error = error,
        _slow = slow;

  @override
  Future<CheckinResult> checkin() async {
    if (_error != null) throw _error;
    return const CheckinResult(
        rewardAmount: 1, alreadyCheckedIn: false, newBalance: 6);
  }

  @override
  Future<PointsInfo> getPoints() async {
    if (_slow) return Completer<PointsInfo>().future;
    if (_error != null) throw _error;
    return _points;
  }

  @override
  Future<({List<PointHistoryItem> items, bool hasMore})> getHistory(
      {int? cursor, int limit = 20}) async {
    if (_slow) {
      return Completer<({List<PointHistoryItem> items, bool hasMore})>().future;
    }
    if (_error != null) throw _error;
    return _history;
  }
}
