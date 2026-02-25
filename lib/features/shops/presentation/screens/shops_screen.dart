import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/base/base_state.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/cubits/shop/shop_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/widgets/shops_list_view.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ShopCubit>();
    if (cubit.state.shops.data == null && !cubit.state.shops.status.isLoading) {
      cubit.loadShops();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(50, 0, 0, 0),
        title: const Text(
          'Grocery Stores',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(14),
        child: ShopsListView(),
      ),
    );
  }
}
