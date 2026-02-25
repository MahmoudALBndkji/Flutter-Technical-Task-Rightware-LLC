import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_router.dart';
import 'package:flutter_technical_task_rightware_llc/core/widgets/logo_animation_loading.dart';

mixin PaginationMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();

  int pageNumber = 1;
  bool _isFetching = false;
  bool _isDialogVisible = false;

  Future<void> onPaginate(int nextPage);

  Widget paginationLoader() => const LogoAnimationLoading(message: 'loading');

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!scrollController.hasClients || _isFetching) return;
    final position = scrollController.position;
    final isScrollingDown =
        position.userScrollDirection == ScrollDirection.reverse;
    final isNearBottom = position.extentAfter < 50;
    if (isScrollingDown && isNearBottom) {
      _startPagination();
    }
  }

  Future<void> _startPagination() async {
    _isFetching = true;
    _showPaginationDialog();
    try {
      await onPaginate(++pageNumber);
    } finally {
      _hidePaginationDialog();
      _isFetching = false;
    }
  }

  void _showPaginationDialog() {
    if (!mounted || _isDialogVisible) return;
    _isDialogVisible = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => paginationLoader(),
      );
    });
  }

  void _hidePaginationDialog() {
    if (!_isDialogVisible || !mounted) return;
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    }
    _isDialogVisible = false;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
