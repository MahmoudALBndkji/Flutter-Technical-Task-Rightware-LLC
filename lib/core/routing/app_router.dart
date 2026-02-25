import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_paths.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/injection_container.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/presentation/screens/users_screen.dart';
import 'package:flutter_technical_task_rightware_llc/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/presentation/cubits/user/user_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/presentation/screens/user_details_screen.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/screens/home_layout.dart';
import 'package:flutter_technical_task_rightware_llc/features/favourite/presentation/cubit/favourite_cubit.dart';

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
          final userCubit = sl<UserCubit>();
          final favouriteCubit = sl<FavouriteCubit>();
          if (userCubit.state.users.data == null ||
              userCubit.state.users.data!.isEmpty) {
            userCubit.getAllUsers();
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeCubit()),
              BlocProvider.value(value: userCubit),
              BlocProvider.value(value: favouriteCubit),
            ],
            child: const HomeLayout(),
          );
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          final userCubit = sl<UserCubit>();
          final favouriteCubit = sl<FavouriteCubit>();
          if (userCubit.state.users.data == null ||
              userCubit.state.users.data!.isEmpty) {
            userCubit.getAllUsers();
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: userCubit),
              BlocProvider.value(value: favouriteCubit),
            ],
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppPaths.users,
            name: 'users',
            builder: (context, state) => const UsersScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'user-details',
                builder: (context, state) {
                  final userId = int.parse(state.pathParameters['id']!);
                  return UserDetailsScreen(userId: userId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
