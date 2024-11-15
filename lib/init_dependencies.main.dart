part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();

  serviceLocator
      .registerLazySingleton<BaseApiServices>(() => NetworkApiService());
  //storage

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => Hive.box(name: "booking"));

  //internet
  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));
}

void _initAuth() {
  //datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator()))
    //repository
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator(), serviceLocator()))
    //use cases
    ..registerFactory(() => Login(serviceLocator()))
    //bloc
    ..registerLazySingleton(() => AuthBloc(serviceLocator()))
    //cubit
    ..registerLazySingleton<PasswordCubit>(() => PasswordCubit())
    ..registerLazySingleton<PasswordConfirmCubit>(() => PasswordConfirmCubit())
    ..registerLazySingleton<RememberMeCubit>(() => RememberMeCubit())
    ..registerLazySingleton<PolicyTermCubit>(() => PolicyTermCubit());
}
