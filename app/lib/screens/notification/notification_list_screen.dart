import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/notification.dart';
import '../../providers/service_providers.dart';
import '../../utils/error_utils.dart';

/// 알림 내역 화면 — 커서 페이지네이션 + 무한 스크롤.
class NotificationListScreen extends ConsumerStatefulWidget {
  const NotificationListScreen({super.key});

  @override
  ConsumerState<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState
    extends ConsumerState<NotificationListScreen> {
  final _scrollController = ScrollController();

  final List<AppNotification> _notifications = [];
  String? _cursor;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadNotifications(refresh: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore && !_isLoadingMore && !_isLoading) {
        _loadNotifications();
      }
    }
  }

  Future<void> _loadNotifications({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isLoading = true;
        _error = null;
        _notifications.clear();
        _cursor = null;
        _hasMore = true;
      });
    } else {
      if (!_hasMore || _isLoadingMore) return;
      setState(() => _isLoadingMore = true);
    }

    try {
      final service = ref.read(notificationServiceProvider);
      final result = await service.getNotifications(cursor: _cursor);

      if (mounted) {
        setState(() {
          _notifications.addAll(result.notifications);
          _cursor = result.cursor;
          _hasMore = result.hasMore;
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyErrorMessage(e);
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _markAsRead(AppNotification notification) async {
    if (notification.isRead) return;
    try {
      final service = ref.read(notificationServiceProvider);
      final updated = await service.markAsRead(notification.id);
      if (mounted) {
        setState(() {
          final idx =
              _notifications.indexWhere((n) => n.id == notification.id);
          if (idx != -1) _notifications[idx] = updated;
        });
      }
    } catch (_) {
      // 읽음 처리 실패 시 무시 — UX를 위해 조용히 처리
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.markAllAsRead();
      if (mounted) {
        setState(() {
          for (var i = 0; i < _notifications.length; i++) {
            _notifications[i] = _notifications[i].copyWith(
              isRead: true,
              readAt: DateTime.now(),
            );
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 알림을 읽음 처리했습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    }
  }

  Future<void> _deleteNotification(AppNotification notification) async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.deleteNotification(notification.id);
      if (mounted) {
        setState(() {
          _notifications.removeWhere((n) => n.id == notification.id);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
        // 스와이프 복원을 위해 다시 로드
        _loadNotifications(refresh: true);
      }
    }
  }

  void _handleTap(AppNotification notification) {
    _markAsRead(notification);
    final deepLink = notification.deepLink;
    if (deepLink != null && deepLink.isNotEmpty) {
      try {
        context.go(deepLink);
      } catch (_) {
        // deepLink가 유효하지 않은 경우 무시
      }
    }
  }

  // ─── 빌드 ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 내역'),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text('모두 읽음'),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              '알림 내역을 불러오지 못했습니다.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style:
                  TextStyle(color: Colors.grey.shade600, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _loadNotifications(refresh: true),
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _loadNotifications(refresh: true),
        child: ListView(
          children: const [
            SizedBox(height: 120),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_none_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '새로운 알림이 없습니다.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadNotifications(refresh: true),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: _notifications.length + (_isLoadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (ctx, index) {
          if (index == _notifications.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final notification = _notifications[index];
          return _NotificationTile(
            notification: notification,
            onTap: () => _handleTap(notification),
            onDismissed: () => _deleteNotification(notification),
          );
        },
      ),
    );
  }
}

/// 알림 항목 타일 — Dismissible 스와이프 삭제 지원.
class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismissed,
  });

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return '방금';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return '${dateTime.month}/${dateTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final unreadBg = Theme.of(context).colorScheme.primaryContainer.withAlpha(40);

    return Dismissible(
      key: ValueKey('notification_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDismissed(),
      child: Material(
        color: isUnread ? unreadBg : null,
        child: ListTile(
          onTap: onTap,
          leading: _buildTypeIcon(notification.notificationType),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight:
                  isUnread ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            notification.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          trailing: Text(
            _formatTime(notification.sentAt),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
            ),
          ),
          isThreeLine: false,
        ),
      ),
    );
  }

  Widget _buildTypeIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'price_alert':
        icon = Icons.price_change;
        color = Colors.blue;
        break;
      case 'keyword_alert':
        icon = Icons.search;
        color = Colors.orange;
        break;
      case 'category_alert':
        icon = Icons.category;
        color = Colors.purple;
        break;
      case 'system':
        icon = Icons.info_outline;
        color = Colors.grey;
        break;
      default:
        icon = Icons.notifications_outlined;
        color = Colors.teal;
    }
    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withAlpha(30),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
