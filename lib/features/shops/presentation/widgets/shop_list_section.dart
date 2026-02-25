import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shops_list_view.dart';

class ShopListSection extends StatelessWidget {
  const ShopListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: const Padding(
        padding: EdgeInsets.fromLTRB(14, 16, 14, 14),
        child: ShopsListView(),
      ),
    );
  }
}
