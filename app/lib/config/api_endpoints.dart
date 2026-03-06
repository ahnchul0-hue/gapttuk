/// API 엔드포인트 경로 상수.
///
/// 모든 서비스에서 API 경로를 하드코딩하지 않고 이 클래스를 참조한다.
abstract final class ApiEndpoints {
  static const String _v1 = '/api/v1';

  // ── Auth ─────────────────────────────────────
  static String authProvider(String provider) => '$_v1/auth/$provider';
  static const String authMe = '$_v1/auth/me';
  static const String authConsent = '$_v1/auth/consent';
  static const String authLogout = '$_v1/auth/logout';
  static const String authRefresh = '$_v1/auth/refresh';

  // ── Products ─────────────────────────────────
  static String product(int id) => '$_v1/products/$id';
  static const String productSearch = '$_v1/products/search';
  static const String productUrl = '$_v1/products/url';
  static String productPrices(int id) => '$_v1/products/$id/prices';
  static String productDailyPrices(int id) => '$_v1/products/$id/prices/daily';
  static const String productPopular = '$_v1/products/popular';

  // ── Alerts ───────────────────────────────────
  static const String alerts = '$_v1/alerts/';
  static const String alertPrice = '$_v1/alerts/price';
  static const String alertCategory = '$_v1/alerts/category';
  static const String alertKeyword = '$_v1/alerts/keyword';
  static String alertPriceUpdate(int id) => '$_v1/alerts/price/$id';
  static String alertKeywordUpdate(int id) => '$_v1/alerts/keyword/$id';
  static String alertPriceToggle(int id) => '$_v1/alerts/price/$id/toggle';
  static String alertCategoryToggle(int id) => '$_v1/alerts/category/$id/toggle';
  static String alertKeywordToggle(int id) => '$_v1/alerts/keyword/$id/toggle';
  static String alertDelete(String type, int id) => '$_v1/alerts/$type/$id';

  // ── Notifications ───────────────────────────
  static const String notifications = '$_v1/notifications/';
  static const String notificationUnreadCount = '$_v1/notifications/unread-count';
  static String notificationRead(int id) => '$_v1/notifications/$id/read';
  static const String notificationReadAll = '$_v1/notifications/read-all';
  static String notificationDelete(int id) => '$_v1/notifications/$id';

  // ── Devices ──────────────────────────────────
  static const String devices = '$_v1/devices/';
  static String deviceDelete(int id) => '$_v1/devices/$id';
  static String devicePushToggle(int id) => '$_v1/devices/$id/push';

  // ── Rewards ──────────────────────────────────
  static const String rewardsCheckin = '$_v1/rewards/checkin';
  static const String rewardsPoints = '$_v1/rewards/points';
  static const String rewardsHistory = '$_v1/rewards/history';

  // ── Predictions ──────────────────────────────
  static String prediction(int id) => '$_v1/predictions/$id';
}
