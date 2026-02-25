import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/api/dio_consumer.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/api/api_consumer.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/api/app_interceptors.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/cubit/language_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/repos/user_repository.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/datasources/user_data_source.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/presentation/cubits/user/user_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/datasources/user_remote_data_source.dart';
import 'package:flutter_technical_task_rightware_llc/features/favourite/presentation/cubit/favourite_cubit.dart';

final sl = GetIt.instance;
Future<void> initServiceLocator() async {
  sl.registerFactory(() => LanguageCubit());
  sl.registerLazySingleton(() => FavouriteCubit());
  sl.registerLazySingleton(
    () => UserCubit(userRepository: sl()),
  );
  sl.registerLazySingleton<UserRepository>(() => UserRepository(sl()));
  sl.registerLazySingleton<UserDataSource>(() => UserRemoteDataSource(sl()));

  // Remote Data Source [API]
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<AppIntercepters>(
    () => AppIntercepters(client: sl()),
  );
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
}
