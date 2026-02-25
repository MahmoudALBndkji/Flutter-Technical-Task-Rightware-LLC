part of 'user_cubit.dart';

class UserState extends Equatable {
  final BaseState<List<DataModel>> users;
  final BaseState<DataModel> userDetails;

  const UserState({
    required this.users,
    required this.userDetails,
  });

  factory UserState.initial() {
    return const UserState(
      users: BaseState<List<DataModel>>(),
      userDetails: BaseState<DataModel>(),
    );
  }

  UserState copyWith({
    BaseState<List<DataModel>>? users,
    BaseState<DataModel>? userDetails,
    bool? isFavorite,
  }) {
    return UserState(
      users: users ?? this.users,
      userDetails: userDetails ?? this.userDetails,
    );
  }

  @override
  List<Object?> get props => [users, userDetails];
}
