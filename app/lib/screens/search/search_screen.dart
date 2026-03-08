import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../models/product.dart';
import '../../providers/service_providers.dart';
import '../../utils/error_utils.dart';
import '../../widgets/product_card.dart';

/// 필터 옵션 정의.
const _filterOptions = <String, String>{
  'near_stockout': '구매 적기',
  'all_time_low': '역대 최저',
  'declining': '하락 중',
  'under_10k': '1만원 이하',
};

/// 정렬 옵션 정의.
const _sortOptions = <String, String>{
  'ranking': '최신순',
  'discount_rate': '할인율순',
  'discount_amount': '할인액순',
  'lowest_price': '저가순',
};

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
  String? _selectedFilter;
  String _selectedSort = 'ranking';

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
        sort: _selectedSort == 'ranking' ? null : _selectedSort,
        filter: _selectedFilter,
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
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onFilterTapped(String value) {
    setState(() {
      _selectedFilter = (_selectedFilter == value) ? null : value;
      _results.clear();
      _cursor = null;
      _hasMore = true;
    });
    _search();
  }

  void _onSortChanged(String value) {
    if (value == _selectedSort) return;
    setState(() {
      _selectedSort = value;
      _results.clear();
      _cursor = null;
      _hasMore = true;
    });
    _search();
  }

  Widget _buildFilterSortBar(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.neutralBorder, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterOptions.entries.map((entry) {
                  final selected = _selectedFilter == entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(entry.value),
                      selected: selected,
                      onSelected: (_) => _onFilterTapped(entry.key),
                      selectedColor:
                          colorScheme.primaryContainer,
                      checkmarkColor:
                          colorScheme.onPrimaryContainer,
                      side: BorderSide(
                        color: selected
                            ? colorScheme.primary
                            : colors.neutralBorder,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          _buildSortButton(context, colors),
        ],
      ),
    );
  }

  Widget _buildSortButton(BuildContext context, AppColors colors) {
    return PopupMenuButton<String>(
      initialValue: _selectedSort,
      onSelected: _onSortChanged,
      tooltip: '정렬',
      position: PopupMenuPosition.under,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: colors.neutralBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort, size: 18, color: colors.neutral),
            const SizedBox(width: 4),
            Text(
              _sortOptions[_selectedSort]!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.neutral),
            ),
            Icon(Icons.arrow_drop_down, size: 18, color: colors.neutral),
          ],
        ),
      ),
      itemBuilder: (context) => _sortOptions.entries
          .map((entry) => PopupMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontWeight: entry.key == _selectedSort
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ))
          .toList(),
    );
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
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _search,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSortBar(context),
          Expanded(
            child: _results.isEmpty && !_loading
                ? Center(
                    child: Text(
                        _hasSearched ? '검색 결과가 없습니다' : '검색어를 입력하세요'),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _results.length + (_loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _results.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
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
