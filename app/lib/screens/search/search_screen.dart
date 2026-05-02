import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../models/product.dart';
import '../../providers/service_providers.dart';
import '../../utils/error_utils.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Product> _results = [];
  String? _cursor;
  bool _hasMore = false;
  bool _loading = false;
  bool _hasSearched = false;
  CancelToken? _cancelToken;

  String? _filter;
  String? _sortBy;

  static const _filters = [
    ('near_stockout', '품절 임박'),
    ('all_time_low', '역대 최저가'),
    ('declining', '하락 중'),
    ('under_10k', '1만원 이하'),
  ];

  static const _sorts = [
    ('ranking', '인기순'),
    ('discount_rate', '할인율순'),
    ('discount_amount', '할인금액순'),
    ('lowest_price', '최저가순'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        _hasMore &&
        !_loading) {
      _search(loadMore: true);
    }
  }

  Future<void> _search({bool loadMore = false}) async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() => _loading = true);
    if (!loadMore) {
      _cancelToken?.cancel();
      _cancelToken = CancelToken();
      _results.clear();
      _cursor = null;
      _hasSearched = true;
    }

    try {
      final service = ref.read(productServiceProvider);
      final result = await service.search(
        query: query,
        filter: _filter,
        sort: _sortBy,
        cursor: _cursor,
        cancelToken: _cancelToken,
      );
      if (mounted) {
        setState(() {
          _results.addAll(result.products);
          _cursor = result.cursor;
          _hasMore = result.hasMore;
        });
      }
    } catch (e, st) {
      if (e is DioException && e.type == DioExceptionType.cancel) return;
      debugPrint('SearchScreen._search: $e\n$st');
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyFilter(String? filter) {
    setState(() => _filter = filter);
    if (_hasSearched) _search();
  }

  void _applySort(String? sort) {
    setState(() => _sortBy = sort);
    if (_hasSearched) _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: '상품명 또는 URL 검색',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
        ),
        actions: [
          DropdownButton<String?>(
            value: _sortBy,
            hint: const Text('정렬'),
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.sort),
            items: [
              const DropdownMenuItem(value: null, child: Text('기본순')),
              ..._sorts.map((e) => DropdownMenuItem(
                    value: e.$1,
                    child: Text(e.$2),
                  )),
            ],
            onChanged: _applySort,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: '검색',
            onPressed: _search,
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterChipRow(
            filters: _filters,
            selected: _filter,
            onChanged: _applyFilter,
          ),
          Expanded(
            child: _results.isEmpty && !_loading
                ? Center(
                    child: Semantics(
                      label: _hasSearched ? '검색 결과가 없습니다' : '검색어를 입력하세요',
                      child: Text(
                          _hasSearched ? '검색 결과가 없습니다' : '검색어를 입력하세요'),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _results.length + (_loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _results.length) {
                        return Semantics(
                          label: '검색 결과 로딩 중',
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.md),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }
                      final product = _results[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push('/product/${product.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipRow extends StatelessWidget {
  final List<(String, String)> filters;
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _FilterChipRow({
    required this.filters,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        spacing: AppSpacing.sm,
        children: filters.map((entry) {
          final (value, label) = entry;
          final isSelected = selected == value;
          return FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onChanged(isSelected ? null : value),
          );
        }).toList(),
      ),
    );
  }
}
