import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_technical_task_rightware_llc/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/screens/shops_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  static final List<Widget> _screens = <Widget>[
    const ShopsScreen(key: ValueKey('shops_screen')),
    const SettingsScreen(key: ValueKey('settings_screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: _screens[state.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (index) => context.read<HomeCubit>().setSelectedIndex(index),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.store_outlined),
                label: 'Shops',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: context.tr('settings'),
              ),
            ],
          ),
        );
      },
    );
  }
}
