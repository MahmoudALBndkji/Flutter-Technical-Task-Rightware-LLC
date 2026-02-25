import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/base/base_state.dart';
import 'package:flutter_technical_task_rightware_llc/core/errors/failures.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/models/user_model.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/repos/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit({
    required UserRepository userRepository,
  }) : _userRepository = userRepository,
       super(UserState.initial());

  Future<void> getAllUsers({int pageId = 1}) async {
    try {
      emit(
        state.copyWith(users: state.users.copyWith(status: BaseStatus.loading)),
      );
      final result = await _userRepository.getAllUsers(pageId);
      final oldUsers = state.users.data ?? [];
      final mergedUsers = pageId == 1 ? result : [...oldUsers, ...result];
      emit(
        state.copyWith(
          users: state.users.copyWith(
            status: BaseStatus.success,
            data: mergedUsers,
          ),
        ),
      );
    } on ServerFailure catch (failure) {
      emitUserStateError(failure.message);
    } on DioException catch (error) {
      final failure = ServerFailure.fromDioException(error);
      emitUserStateError(failure.message);
    } catch (_) {
      emitUserStateError('general_error'.tr());
    }
  }

  void emitUserStateError(String errorMessage) => emit(
    state.copyWith(
      users: state.users.copyWith(
        status: BaseStatus.failure,
        error: errorMessage,
      ),
    ),
  );

  Future<void> getUserDetails(int userId) async {
    try {
      emit(
        state.copyWith(
          userDetails: state.userDetails.copyWith(status: BaseStatus.loading),
        ),
      );
      final result = await _userRepository.getUserDetails(userId);
      emit(
        state.copyWith(
          userDetails: state.userDetails.copyWith(
            status: BaseStatus.success,
            data: result,
          ),
        ),
      );
    } on ServerFailure catch (failure) {
      emitUserDetailsStateError(failure.message);
    } on DioException catch (error) {
      final failure = ServerFailure.fromDioException(error);
      emitUserDetailsStateError(failure.message);
    } catch (_) {
      emitUserDetailsStateError('general_error'.tr());
    }
  }

  void emitUserDetailsStateError(String errorMessage) => emit(
    state.copyWith(
      userDetails: state.userDetails.copyWith(
        status: BaseStatus.failure,
        error: errorMessage,
      ),
    ),
  );
}
