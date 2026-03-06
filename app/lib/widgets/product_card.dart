import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/theme.dart';
import '../models/product.dart';

/// 상품 카드 위젯 — 검색 결과, 홈 목록 등에서 재사용.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat('#,###', 'ko_KR');
    final appColors = Theme.of(context).extension<AppColors>()!;

    final trendLabel = switch (product.priceTrend) {
      'falling' => '가격 하락 중',
      'rising' => '가격 상승 중',
      'stable' => '가격 보합',
      _ => null,
    };

    return Semantics(
      button: onTap != null,
      label: [
        product.productName,
        if (product.currentPrice != null)
          '${priceFormat.format(product.currentPrice)}원',
        ?trendLabel,
      ].join(', '),
      child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        excludeFromSemantics: true,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 상품 이미지
              ExcludeSemantics(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: product.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: product.imageUrl!,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Container(
                            width: 72,
                            height: 72,
                            color: appColors.neutralLight,
                          ),
                          errorWidget: (_, _, _) => _placeholderImage(appColors),
                        )
                      : _placeholderImage(appColors),
                ),
              ),
              const SizedBox(width: 12),

              // 상품 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    if (product.currentPrice != null)
                      Text(
                        '₩${priceFormat.format(product.currentPrice)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                  ],
                ),
              ),

              // 가격 트렌드 아이콘
              if (product.priceTrend != null)
                ExcludeSemantics(child: Icon(
                  product.priceTrend == 'falling'
                      ? Icons.trending_down
                      : product.priceTrend == 'rising'
                          ? Icons.trending_up
                          : Icons.trending_flat,
                  color: product.priceTrend == 'falling'
                      ? AppTheme.priceDown
                      : product.priceTrend == 'rising'
                          ? AppTheme.priceUp
                          : appColors.neutral,
                )),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _placeholderImage(AppColors appColors) {
    return Container(
      width: 72,
      height: 72,
      color: appColors.neutralLight,
      child: Icon(Icons.image, color: appColors.neutral),
    );
  }
}
