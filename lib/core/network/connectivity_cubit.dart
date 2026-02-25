import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit() : super(ConnectivityStatus.online) {
    _subscription = Connectivity().onConnectivityChanged.listen(_onResult);
    _checkInitial();
  }

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  Future<void> _checkInitial() async {
    final result = await Connectivity().checkConnectivity();
    _emitFromResult(result);
  }

  void _onResult(List<ConnectivityResult> result) {
    _emitFromResult(result);
  }

  void _emitFromResult(List<ConnectivityResult> result) {
    final isOffline = result.isEmpty ||
        result.every((r) =>
            r == ConnectivityResult.none || r == ConnectivityResult.other);
    emit(isOffline ? ConnectivityStatus.offline : ConnectivityStatus.online);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
