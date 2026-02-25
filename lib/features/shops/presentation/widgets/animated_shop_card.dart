import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shop_card.dart';

/// Wraps [ShopCard] with a staggered fade-in animation for list entrance.
class AnimatedShopCard extends StatefulWidget {
  const AnimatedShopCard({
    super.key,
    required this.shop,
    required this.index,
  });

  final ShopModel shop;
  final int index;

  @override
  State<AnimatedShopCard> createState() => _AnimatedShopCardState();
}

class _AnimatedShopCardState extends State<AnimatedShopCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    final delay = (widget.index * 50).clamp(0, 300);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ShopCard(shop: widget.shop),
    );
  }
}
