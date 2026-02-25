import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/base/base_state.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/presentation/widgets/loading_column.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/presentation/cubits/user/user_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:go_router/go_router.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.userId});
  final int userId;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUserDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('user_details')),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          BlocBuilder<UserCubit, UserState>(
            buildWhen: (p, c) => c.userDetails.status.isSuccess,
            builder: (context, userState) {
              if (userState.userDetails.status.isSuccess) {
                return BlocBuilder<FavouriteCubit, FavouriteState>(
                  builder: (context, favouriteState) {
                    final isFavourite =
                        favouriteState.favourites.data?.any(
                          (fav) => fav.id == widget.userId,
                        ) ??
                        false;
                    return IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isFavourite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        final user = userState.userDetails.data!;
                        if (isFavourite) {
                          context.read<FavouriteCubit>().removeFavourite(
                            widget.userId,
                          );
                        } else {
                          context.read<FavouriteCubit>().addFavourite(user);
                        }
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state.userDetails.status.isFailure &&
              state.userDetails.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.userDetails.error!)));
          }
        },
        buildWhen: (p, c) => p.userDetails != c.userDetails,
        builder: (context, state) {
          if (state.userDetails.status.isLoading ||
              state.userDetails.status.isInitial) {
            return const LoadingColumn(message: 'loading');
          }
          if (state.userDetails.status.isFailure) {
            return Center(child: Text(state.userDetails.error ?? 'Error'));
          }
          final user = state.userDetails.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 36,
                  child: Text(
                    user.username?.substring(0, 1).toUpperCase() ?? '?',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow(label: 'Email', value: user.email ?? '-'),
                        _InfoRow(
                          label: 'Username',
                          value: user.username ?? '-',
                        ),
                        _InfoRow(label: 'Phone', value: user.phone ?? '-'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
