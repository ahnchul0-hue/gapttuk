import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      body: _results.isEmpty && !_loading
          ? Center(
              child: Text(_hasSearched ? '검색 결과가 없습니다' : '검색어를 입력하세요'),
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
    );
  }
}
