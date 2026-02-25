import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/base/base_state.dart';
import 'package:flutter_technical_task_rightware_llc/core/mixins/pagination_mixin.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/presentation/widgets/loading_column.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/presentation/cubits/user/user_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/presentation/widgets/user_card.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> with PaginationMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state.users.status.isFailure && state.users.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.users.error!)));
        }
      },
      buildWhen: (p, c) => p.users != c.users,
      builder: (context, state) {
        if (state.users.status.isLoading && state.users.data == null) {
          return const LoadingColumn(message: 'loading');
        }
        if (state.users.status.isFailure) {
          return Center(child: Text(state.users.error ?? 'Error'));
        }

        final users = state.users.data ?? [];
        if (users.isEmpty) {
          return const Center(child: Text('No Users Yet'));
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: users.length,
          itemBuilder: (_, i) => UserCard(user: users[i]),
        );
      },
    );
  }

  @override
  Future<void> onPaginate(int nextPage) async {
    await context.read<UserCubit>().getAllUsers(pageId: nextPage);
  }
}
