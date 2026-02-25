import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_paths.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/injection_container.dart';
import 'package:flutter_technical_task_rightware_llc/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/screens/home_layout.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/cubits/shop/shop_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/screens/shop_details_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppPaths.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppPaths.home,
        name: 'home',
        builder: (context, state) {
          final shopCubit = sl<ShopCubit>();
          if (shopCubit.state.shops.data == null ||
              shopCubit.state.shops.data!.isEmpty) {
            shopCubit.loadShops();
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeCubit()),
              BlocProvider.value(value: shopCubit),
              BlocProvider.value(value: sl<FavoritesCubit>()),
            ],
            child: const HomeLayout(),
          );
        },
      ),
      GoRoute(
        path: AppPaths.shopDetails,
        name: 'shop-details',
        builder: (context, state) {
          final shop = state.extra as ShopModel;
          return BlocProvider.value(
            value: sl<FavoritesCubit>(),
            child: ShopDetailsScreen(shop: shop),
          );
        },
      ),
    ],
  );
}
