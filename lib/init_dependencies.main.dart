part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());
  serviceLocator.registerLazySingleton<NetworkApiService>(() =>
      NetworkApiService(
          baseUrl: "https://solaceapi.ddnsking.com/api",
          authService: serviceLocator<AuthService>()));

  //on boarding
  serviceLocator.registerLazySingleton(() => OnboardingBloc());

  //storage

  //internet
  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));

  await _initAuth();
  await _initMenu();
  await _initProduct();
  await _initService();
  await _initCategory();
}

Future<void> _initAuth() async {
  //datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    //repository
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        serviceLocator<AuthRemoteDataSource>(),
        serviceLocator<ConnectionChecker>(),
        serviceLocator<AuthService>()))

    //use cases
    ..registerFactory(() => Login(serviceLocator()))
    ..registerFactory(() => SignUp(serviceLocator()))
    ..registerFactory(() => VerifyOtp(serviceLocator()))
    ..registerFactory(() => ForgetPassword(serviceLocator()))
    ..registerFactory(() => ResetPassword(serviceLocator()))
    ..registerFactory(() => ResendOtp(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => AuthBloc(serviceLocator()))
    //cubit
    ..registerLazySingleton<PasswordCubit>(() => PasswordCubit())
    ..registerLazySingleton<PasswordConfirmCubit>(() => PasswordConfirmCubit())
    ..registerLazySingleton<RememberMeCubit>(() => RememberMeCubit())
    ..registerLazySingleton<PolicyTermCubit>(() => PolicyTermCubit())
    ..registerLazySingleton<PasswordMatchCubit>(() => PasswordMatchCubit());
}

Future<void> _initMenu() async {
  serviceLocator.registerLazySingleton(() => NavigationBloc());
}

Future<void> _initProduct() async {
  serviceLocator
      .registerLazySingleton<CheckboxCartCubit>(() => CheckboxCartCubit());
}

Future<void> _initService() async {
  serviceLocator
    //data src
    ..registerFactory<ServiceRemoteDataSrc>(
        () => ServiceRemoteDataSrcImpl(serviceLocator<NetworkApiService>()))
    //repo
    ..registerFactory<ServiceRepository>(() => ServiceRepositoryImpl(
        serviceLocator<ServiceRemoteDataSrc>(),
        serviceLocator<ConnectionChecker>()))
    //use case
    ..registerLazySingleton(() => GetListService(serviceLocator()))
    ..registerLazySingleton(() => GetServiceDetail(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => ServiceBloc(serviceLocator()));
}

Future<void> _initCategory() async {
  serviceLocator
    //data src
    ..registerFactory<CategoryRemoteDataSource>(
        () => CategoryRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    //repo
    ..registerFactory<CategoryRepository>(() => CategoryRepositoryImpl(
          serviceLocator<CategoryRemoteDataSource>(),
        ))
    //use case
    ..registerLazySingleton(() => GetListCategories(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => ListCategoryBloc(serviceLocator()));
}
