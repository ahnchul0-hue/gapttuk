import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/product_provider.dart';
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
                                  child: Text('${s['rank'] ?? ''}'),
                                ),
                                title: Text(s['keyword'] as String? ?? ''),
                                dense: true,
                              ))
                          .toList(),
                    ),
              loading: () => const LoadingSkeleton(itemCount: 5),
              error: (e, _) => Center(child: Text('오류: $e')),
            ),
          ],
        ),
      ),
    );
  }
}
