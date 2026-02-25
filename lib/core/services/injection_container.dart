import 'package:dio/dio.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/security_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/api/api_consumer.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/api/app_interceptors.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/api/dio_consumer.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/cubit/language_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/datasources/shop_data_source.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/datasources/shop_remote_data_source.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/repos/shop_repository.dart';
import 'package:flutter_technical_task_rightware_llc/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/presentation/cubits/shop/shop_cubit.dart';

final sl = GetIt.instance;
Future<void> initServiceLocator() async {
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<AppIntercepters>(
    () => AppIntercepters(client: sl()),
  );
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));

  sl.registerFactory(() => LanguageCubit());

  sl.registerLazySingleton<ShopDataSource>(() => ShopRemoteDataSource(sl()));
  sl.registerLazySingleton<ShopRepository>(() => ShopRepository(sl()));
  sl.registerLazySingleton<ShopCubit>(() => ShopCubit(repository: sl()));
  sl.registerLazySingleton<FavoritesCubit>(() => FavoritesCubit());

  // Security Service
  sl.registerLazySingleton(() => SecurityService());
}
