import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/security_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter_technical_task_rightware_llc/my_app.dart';
import 'package:flutter_technical_task_rightware_llc/core/env/init_env.dart';
import 'package:flutter_technical_task_rightware_llc/core/errors/custom_error.dart';
import 'package:flutter_technical_task_rightware_llc/core/network/bloc_observer.dart';
import 'package:flutter_technical_task_rightware_llc/core/network/local/http_certificate.dart';
import 'package:flutter_technical_task_rightware_llc/core/network/local/secure_storage.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initEnv();
  await SecureStorage.instance.init();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  customError();
  Bloc.observer = MyBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await initServiceLocator();
  runApp(const MyApp());
}
