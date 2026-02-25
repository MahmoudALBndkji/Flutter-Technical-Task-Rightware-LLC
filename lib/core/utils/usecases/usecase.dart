import 'package:flutter_technical_task_rightware_llc/core/utils/typedef.dart';

abstract class Usecase<T> {
  FutureResult<T> call();
}

abstract class UsecaseWithParams<T, Params> {
  FutureResult<T> call(Params params);
}
