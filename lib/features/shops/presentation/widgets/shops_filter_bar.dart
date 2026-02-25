import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/cubits/shop/shop_cubit.dart';

/// Responsive filter bar: sort dropdown + open-only switch.
/// Stacks vertically on narrow screens to avoid overflow.
class ShopsFilterBar extends StatefulWidget {
  const ShopsFilterBar({
    super.key,
    required this.sortBy,
    required this.openOnly,
    required this.onSortChanged,
    required this.onOpenOnlyChanged,
  });

  final ShopSortBy sortBy;
  final bool openOnly;
  final ValueChanged<ShopSortBy> onSortChanged;
  final ValueChanged<bool> onOpenOnlyChanged;

  @override
  State<ShopsFilterBar> createState() => _ShopsFilterBarState();
}

class _ShopsFilterBarState extends State<ShopsFilterBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  static const double _breakpoint = 360;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < _breakpoint;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnim,
          child: isNarrow
              ? _buildColumnLayout(context)
              : _buildRowLayout(context),
        );
      },
    );
  }

  Widget _buildRowLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _SortDropdown(
            value: widget.sortBy,
            onChanged: widget.onSortChanged,
          ),
        ),
        const SizedBox(width: 12),
        _OpenOnlyChip(
          value: widget.openOnly,
          onChanged: widget.onOpenOnlyChanged,
        ),
      ],
    );
  }

  Widget _buildColumnLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SortDropdown(value: widget.sortBy, onChanged: widget.onSortChanged),
        const SizedBox(height: 10),
        _OpenOnlyChip(
          value: widget.openOnly,
          onChanged: widget.onOpenOnlyChanged,
        ),
      ],
    );
  }
}

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({required this.value, required this.onChanged});

  final ShopSortBy value;
  final ValueChanged<ShopSortBy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonFormField<ShopSortBy>(
        value: value,
        isExpanded: true,
        dropdownColor: AppColors.secondaryColor.withValues(alpha: 0.98),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
        ),
        items: [
          DropdownMenuItem(
            value: ShopSortBy.none,
            child: Text(
              context.tr('sort'),
              style: TextStyle(
                color: AppColors.primaryColor.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          DropdownMenuItem(
            value: ShopSortBy.etaAsc,
            child: Text(
              context.tr('sort_eta_asc'),
              style: TextStyle(
                color: AppColors.primaryColor.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          DropdownMenuItem(
            value: ShopSortBy.minOrderAsc,
            child: Text(
              context.tr('sort_min_order_asc'),
              style: TextStyle(
                color: AppColors.primaryColor.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

class _OpenOnlyChip extends StatelessWidget {
  const _OpenOnlyChip({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: value
          ? AppColors.primaryColor.withValues(alpha: 0.15)
          : AppColors.secondaryColor.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                value ? Icons.check_circle_rounded : Icons.filter_list_rounded,
                size: 20,
                color: value
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Text(
                context.tr('open_only'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
