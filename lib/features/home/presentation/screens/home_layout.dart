import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_technical_task_rightware_llc/features/favourite/presentation/screens/favourite_screen.dart';
import 'package:flutter_technical_task_rightware_llc/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/presentation/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  static final List<Widget> _screens = <Widget>[
    const UsersScreen(key: ValueKey('users_screen')),
    const FavouriteScreen(key: ValueKey('favourite_screen')),
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
                icon: Icon(Icons.group_outlined),
                label: context.tr('users'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined),
                label: context.tr('favourite'),
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
