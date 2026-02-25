import 'package:flutter/material.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_paths.dart';
import 'package:flutter_technical_task_rightware_llc/features/favourite/presentation/cubit/favourite_cubit.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final DataModel user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouriteCubit, FavouriteState>(
      builder: (context, favouriteState) {
        final isFavourite =
            favouriteState.favourites.data?.any((fav) => fav.id == user.id) ??
            false;
        return Card(
          margin: EdgeInsets.only(bottom: 20),
          child: ListTile(
            onTap: () => context.push('${AppPaths.users}/${user.id}'),
            title: Text(user.email ?? ''),
            minVerticalPadding: 20,
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(user.username ?? ''), Text(user.phone ?? '')],
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                color: isFavourite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                if (isFavourite) {
                  context.read<FavouriteCubit>().removeFavourite(user.id ?? 0);
                } else {
                  context.read<FavouriteCubit>().addFavourite(user);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
