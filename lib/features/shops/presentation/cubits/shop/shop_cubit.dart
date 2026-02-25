import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/core/base/base_state.dart';
import 'package:flutter_technical_task_rightware_llc/core/errors/failures.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/repos/shop_repository.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  final ShopRepository _repository;

  ShopCubit({required ShopRepository repository})
      : _repository = repository,
        super(ShopState(
          shops: const BaseState<List<ShopModel>>(),
        ));

  Future<void> loadShops() async {
    try {
      emit(state.copyWith(
        shops: state.shops.copyWith(status: BaseStatus.loading),
      ));
      final list = await _repository.getAllShops();
      emit(state.copyWith(
        shops: state.shops.copyWith(
          status: BaseStatus.success,
          data: list,
        ),
      ));
    } on ServerFailure catch (f) {
      emit(state.copyWith(
        shops: state.shops.copyWith(
          status: BaseStatus.failure,
          error: f.message,
        ),
      ));
    } on DioException catch (e) {
      final f = ServerFailure.fromDioException(e);
      emit(state.copyWith(
        shops: state.shops.copyWith(
          status: BaseStatus.failure,
          error: f.message,
        ),
      ));
    } catch (_) {
      emit(state.copyWith(
        shops: state.shops.copyWith(
          status: BaseStatus.failure,
          error: 'Something went wrong',
        ),
      ));
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setSortBy(ShopSortBy sortBy) {
    emit(state.copyWith(sortBy: sortBy));
  }

  void setOpenOnly(bool openOnly) {
    emit(state.copyWith(openOnly: openOnly));
  }

  void clearFilters() {
    emit(state.copyWith(
      searchQuery: '',
      sortBy: ShopSortBy.none,
      openOnly: false,
    ));
  }
}
