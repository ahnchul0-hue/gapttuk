import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/alert.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../providers/service_providers.dart';
import '../../utils/error_utils.dart';

/// 즐겨찾기 화면 — 가격 알림이 설정된 상품 그리드.
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  bool _isLoading = false;
  String? _error;
  List<PriceAlert> _priceAlerts = [];
  final Map<int, Product> _products = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final alertService = ref.read(alertServiceProvider);
      final alerts = await alertService.getAlerts();
      final priceAlerts = alerts.priceAlerts;

      // 고유한 productId 집합으로 상품 정보 로드
      final productIds =
          priceAlerts.map((a) => a.productId).toSet();

      final Map<int, Product> products = {};
      await Future.wait(
        productIds.map((id) async {
          try {
            final product =
                await ref.read(productDetailProvider(id).future);
            products[id] = product;
          } catch (_) {
            // 개별 상품 로드 실패 시 건너뜀
          }
        }),
      );

      if (mounted) {
        setState(() {
          _priceAlerts = priceAlerts;
          _products
            ..clear()
            ..addAll(products);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyErrorMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  // ─── 알림 타입 뱃지 ────────────────────────────────────────────────────────

  String _alertTypeBadge(String type) {
    switch (type) {
      case 'target_price':
        return '목표가';
      case 'below_average':
        return '평균 이하';
      case 'near_lowest':
        return '최저가 근접';
      case 'all_time_low':
        return '최저가 갱신';
      default:
        return type;
    }
  }

  Color _alertTypeBadgeColor(String type) {
    switch (type) {
      case 'target_price':
        return Colors.blue;
      case 'below_average':
        return Colors.green;
      case 'near_lowest':
        return Colors.orange;
      case 'all_time_low':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ─── 가격 포맷 ─────────────────────────────────────────────────────────────

  String _formatPrice(int price) {
    return NumberFormat('#,###').format(price);
  }

  // ─── 상품 카드 ─────────────────────────────────────────────────────────────

  Widget _buildProductCard(PriceAlert alert, Product? product) {
    final imageUrl = product?.imageUrl;
    final productName = product?.productName ?? '상품 #${alert.productId}';
    final currentPrice = product?.currentPrice;

    return GestureDetector(
      onTap: () => context.push('/product/${alert.productId}'),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상품 이미지
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => _buildImagePlaceholder(),
                    )
                  else
                    _buildImagePlaceholder(),
                  // 활성 상태 표시
                  if (!alert.isActive)
                    Container(
                      color: Colors.black45,
                      child: const Center(
                        child: Text(
                          '비활성',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // 알림 유형 뱃지
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildBadge(
                      _alertTypeBadge(alert.alertType),
                      _alertTypeBadgeColor(alert.alertType),
                    ),
                  ),
                ],
              ),
            ),
            // 상품 정보
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (currentPrice != null)
                    Text(
                      '${_formatPrice(currentPrice)}원',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  else if (product == null)
                    Text(
                      '가격 정보 없음',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Icon(
        Icons.shopping_bag_outlined,
        size: 48,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
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

  // ─── 빈 상태 ──────────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 72,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '가격 알림을 설정하면 여기에 표시됩니다',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/search'),
            icon: const Icon(Icons.search),
            label: const Text('상품 검색하러 가기'),
          ),
        ],
      ),
    );
  }

  // ─── 빌드 ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        actions: [
          if (!_isLoading && _priceAlerts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  '${_priceAlerts.length}개',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
              '즐겨찾기를 불러오지 못했습니다',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_priceAlerts.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: _priceAlerts.length,
        itemBuilder: (ctx, i) {
          final alert = _priceAlerts[i];
          final product = _products[alert.productId];
          return _buildProductCard(alert, product);
        },
      ),
    );
  }
}
