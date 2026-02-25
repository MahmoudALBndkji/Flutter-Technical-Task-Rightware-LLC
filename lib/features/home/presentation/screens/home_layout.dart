import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:flutter_technical_task_rightware_llc/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/screens/shops_screen.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});
  static final List<Widget> _screens = <Widget>[
    const ShopsScreen(key: ValueKey('shops_screen')),
    const FavoritesScreen(key: ValueKey('favorites_screen')),
    const SettingsScreen(key: ValueKey('settings_screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: _screens[state.selectedIndex],
          bottomNavigationBar: HomeBottomNavBar(
            selectedIndex: state.selectedIndex,
          ),
        );
      },
    );
  }
}
