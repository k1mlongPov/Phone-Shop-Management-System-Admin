import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';

class InventoryTab<T> extends StatelessWidget {
  final dynamic controllerListenable;
  final bool paged;
  final Widget Function(BuildContext, T)? itemBuilder;
  final Widget Function(BuildContext, T)? pageBuilder;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;

  const InventoryTab({
    super.key,
    required this.controllerListenable,
    this.paged = false,
    this.itemBuilder,
    this.pageBuilder,
    required this.onRefresh,
    required this.onLoadMore,
  });

  List<T> _items() {
    try {
      if (controllerListenable == null) return <T>[];
      final c = controllerListenable as dynamic;
      if (c.items != null) return (c.items as RxList<T>).toList();
      if (c.list != null) return (c.list as RxList<T>).toList();
      if (c.phones != null) return (c.phones as RxList<T>).toList();
      if (c.accessories != null) return (c.accessories as RxList<T>).toList();
      if (c.categories != null) return (c.categories as RxList<T>).toList();
      if (c.suppliers != null) return (c.suppliers as RxList<T>).toList();
    } catch (_) {}
    return <T>[];
  }

  bool _isLoading() {
    try {
      return (controllerListenable as dynamic).isLoading.value;
    } catch (_) {
      return false;
    }
  }

  bool _isLoadingMore() {
    try {
      return (controllerListenable as dynamic).isLoadingMore.value;
    } catch (_) {
      return false;
    }
  }

  String? _error() {
    try {
      return (controllerListenable as dynamic).error.value;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = _items();
      final loading = _isLoading();
      final loadingMore = _isLoadingMore();
      final error = _error();

      if (loading && items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (error != null && items.isEmpty) {
        return Center(child: Text('Error: $error'));
      }
      if (paged && pageBuilder != null) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: PageView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return pageBuilder!(context, item);
            },
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: onRefresh,
        backgroundColor: AppColors.kWhite,
        color: AppColors.kPrimary,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >=
                (notification.metrics.maxScrollExtent - 200)) {
              if (!loadingMore) onLoadMore();
            }
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length + (loadingMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final item = items[index];
              return itemBuilder!(context, item);
            },
          ),
        ),
      );
    });
  }
}
