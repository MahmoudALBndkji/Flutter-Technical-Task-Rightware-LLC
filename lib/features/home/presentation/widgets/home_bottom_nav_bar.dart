import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/constants/app_colors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter_technical_task_rightware_llc/features/home/presentation/cubit/home_cubit.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  const HomeBottomNavBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.blackColor.withValues(alpha: 0.9),
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.whiteColor,
      currentIndex: selectedIndex,
      onTap: (index) => context.read<HomeCubit>().setSelectedIndex(index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.store_outlined),
          label: context.tr('grocery_stores'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: context.tr('favourites'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: context.tr('settings'),
        ),
      ],
    );
  }
}
