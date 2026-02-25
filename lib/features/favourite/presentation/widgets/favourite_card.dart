import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_technical_task_rightware_llc/core/routing/app_paths.dart';
import 'package:flutter_technical_task_rightware_llc/features/favourite/presentation/cubit/favourite_cubit.dart';

class FavouriteCard extends StatelessWidget {
  const FavouriteCard({super.key, required this.user});
  final DataModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => context.push('${AppPaths.users}/${user.id}'),
        onLongPress: () => _showBottomSheet(context),
        title: Text(user.email ?? ''),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(user.username ?? ''), Text(user.phone ?? '')],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            context.read<FavouriteCubit>().removeFavourite(user.id ?? 0);
          },
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    child: Text(
                      user.username?.substring(0, 1).toUpperCase() ?? '?',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _InfoRow(label: 'ID', value: user.id?.toString() ?? '-'),
                _InfoRow(label: 'Email', value: user.email ?? '-'),
                _InfoRow(label: 'Username', value: user.username ?? '-'),
                _InfoRow(label: 'Phone', value: user.phone ?? '-'),
                if (user.name != null) ...[
                  _InfoRow(
                    label: 'First Name',
                    value: user.name!.firstname ?? '-',
                  ),
                  _InfoRow(
                    label: 'Last Name',
                    value: user.name!.lastname ?? '-',
                  ),
                ],
                if (user.address != null) ...[
                  _InfoRow(label: 'Street', value: user.address!.street ?? '-'),
                  _InfoRow(label: 'City', value: user.address!.city ?? '-'),
                  _InfoRow(
                    label: 'Zipcode',
                    value: user.address!.zipcode ?? '-',
                  ),
                  _InfoRow(
                    label: 'Country',
                    value: user.address!.country ?? '-',
                  ),
                ],
                if (user.orders != null && user.orders!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Orders',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.orders!.join(', '),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
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
            width: 100,
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
