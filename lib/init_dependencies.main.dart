part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton<NetworkApiService>(
      () => NetworkApiService(baseUrl: "http://localhost:8080"));

  //on boarding
  serviceLocator.registerLazySingleton(() => OnboardingBloc());

  //storage

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => Hive.box(name: "booking"));

  //internet
  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));

  await _initAuth();
  await _initMenu();
  await _initProduct();

  print(serviceLocator.isRegistered<NetworkApiService>());
}

Future<void> _initAuth() async {
  //datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    //repository
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        serviceLocator<AuthRemoteDataSource>(),
        serviceLocator<ConnectionChecker>()))

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

Future<void> _initMenu() async {
  serviceLocator.registerLazySingleton(() => NavigationBloc());
}

Future<void> _initProduct() async {
  serviceLocator
      .registerLazySingleton<CheckboxCartCubit>(() => CheckboxCartCubit());
}
