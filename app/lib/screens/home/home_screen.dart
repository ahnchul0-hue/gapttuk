import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/product_provider.dart';
import '../../providers/service_providers.dart';
import '../../utils/error_utils.dart';
import '../../widgets/loading_skeleton.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularAsync = ref.watch(popularSearchesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('값뚝')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(popularSearchesProvider.future),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 검색 바
            GestureDetector(
              onTap: () => context.go('/search'),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Text(
                      '상품명 또는 URL을 검색하세요',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // URL로 상품 추가 카드
            Card(
              child: ListTile(
                leading: const Icon(Icons.add_link),
                title: const Text('URL로 상품 추가'),
                subtitle: const Text('쇼핑몰 URL을 붙여넣어 상품을 추적하세요'),
                onTap: () => _showAddByUrlDialog(context, ref),
              ),
            ),

            const SizedBox(height: 24),

            // 인기 검색어
            Text('인기 검색어',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            popularAsync.when(
              data: (searches) => searches.isEmpty
                  ? const Center(child: Text('인기 검색어가 없습니다'))
                  : Column(
                      children: searches
                          .take(10)
                          .map((s) => ListTile(
                                leading: CircleAvatar(
                                  child: Text('${s.rank}'),
                                ),
                                title: Text(s.keyword),
                                trailing: s.trend != null
                                    ? _trendIcon(s.trend!)
                                    : null,
                                dense: true,
                              ))
                          .toList(),
                    ),
              loading: () => const LoadingSkeleton(itemCount: 5),
              error: (e, st) =>
                  Center(child: Text(friendlyErrorMessage(e))),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddByUrlDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    bool isLoading = false;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('URL로 상품 추가'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'https://www.coupang.com/...',
              labelText: '상품 URL',
            ),
            keyboardType: TextInputType.url,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final url = controller.text.trim();
                      if (url.isEmpty) return;
                      setState(() => isLoading = true);
                      try {
                        final service = ref.read(productServiceProvider);
                        final result = await service.addByUrl(url);
                        if (context.mounted) {
                          Navigator.pop(context);
                          context.push('/product/${result.id}');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(friendlyErrorMessage(e))),
                          );
                        }
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('추가'),
            ),
          ],
        ),
      ),
    ).then((_) => controller.dispose());
  }

  Widget _trendIcon(String trend) {
    switch (trend) {
      case 'up':
        return const Icon(Icons.trending_up, color: Colors.red, size: 18);
      case 'down':
        return const Icon(Icons.trending_down, color: Colors.blue, size: 18);
      case 'new':
        return const Text('NEW',
            style: TextStyle(color: Colors.orange, fontSize: 12));
      default:
        return const Icon(Icons.trending_flat, color: Colors.grey, size: 18);
    }
  }
}
