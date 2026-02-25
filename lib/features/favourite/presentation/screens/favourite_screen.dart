import 'package:flutter_technical_task_rightware_llc/core/base/base_state.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/favourite/presentation/widgets/favourite_card.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/models/user_model.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('favourite'))),
      body: BlocBuilder<FavouriteCubit, FavouriteState>(
        builder: (context, state) {
          if (state.favourites.status.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.favourites.status.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    state.favourites.error ?? 'An error occurred',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavouriteCubit>().loadFavourites();
                    },
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          }
          if (state.favourites.data?.isEmpty ?? true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('no_favourites_yet'),
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: state.favourites.data?.length ?? 0,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = state.favourites.data?[index] ?? DataModel();
              return FavouriteCard(user: user);
            },
          );
        },
      ),
    );
  }
}
