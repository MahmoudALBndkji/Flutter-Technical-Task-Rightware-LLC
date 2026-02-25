import 'package:equatable/equatable.dart';

enum BaseStatus { initial, loading, success, failure }

extension BaseStatusX on BaseStatus {
  bool get isInitial => this == BaseStatus.initial;
  bool get isLoading => this == BaseStatus.loading;
  bool get isSuccess => this == BaseStatus.success;
  bool get isFailure => this == BaseStatus.failure;
}

class BaseState<T> extends Equatable {
  final BaseStatus status;
  final T? data;
  final String? error;

  const BaseState({
    this.status = BaseStatus.initial,
    this.data,
    this.error,
  });

  BaseState<T> copyWith({
    BaseStatus? status,
    T? data,
    String? error,
  }) {
    return BaseState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, data, error];
}
