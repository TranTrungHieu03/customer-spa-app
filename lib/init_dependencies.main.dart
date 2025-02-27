part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());
  serviceLocator.registerLazySingleton<NetworkApiService>(
      () => NetworkApiService(baseUrl: "https://solaceapi.ddnsking.com/api", authService: serviceLocator<AuthService>()));

  //on boarding
  serviceLocator.registerLazySingleton(() => OnboardingBloc());

  //storage
  serviceLocator.registerLazySingleton<LocalStorage>(() => LocalStorage());
  //internet
  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocator()));

  await _initAuth();
  await _initMenu();
  await _initProduct();
  await _initService();
  await _initCategory();
  await _initAppointment();
  await _initAiChat();
  await _initSkinAnalysis();
}

Future<void> _initAuth() async {
  //datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    //repository
    ..registerFactory<AuthRepository>(() =>
        AuthRepositoryImpl(serviceLocator<AuthRemoteDataSource>(), serviceLocator<ConnectionChecker>(), serviceLocator<AuthService>()))

    //use cases
    ..registerFactory(() => Login(serviceLocator()))
    ..registerFactory(() => SignUp(serviceLocator()))
    ..registerFactory(() => VerifyOtp(serviceLocator()))
    ..registerFactory(() => ForgetPassword(serviceLocator()))
    ..registerFactory(() => ResetPassword(serviceLocator()))
    ..registerFactory(() => ResendOtp(serviceLocator()))
    ..registerFactory(() => GetUserInformation(serviceLocator()))
    ..registerFactory(() => LoginWithGoogle(serviceLocator()))
    ..registerFactory(() => LoginWithFacebook(serviceLocator()))
    ..registerFactory(() => Logout(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => AuthBloc(
          login: serviceLocator(),
          signUp: serviceLocator(),
          googleLogin: serviceLocator(),
          facebookLogin: serviceLocator(),
          verifyEvent: serviceLocator(),
          forgetPassword: serviceLocator(),
          resetPassword: serviceLocator(),
          resendOtp: serviceLocator(),
          getUserInformation: serviceLocator(),
          logout: serviceLocator(),
        ))
    //cubit
    ..registerLazySingleton<PasswordCubit>(() => PasswordCubit())
    ..registerLazySingleton<PasswordConfirmCubit>(() => PasswordConfirmCubit())
    ..registerLazySingleton<RememberMeCubit>(() => RememberMeCubit())
    ..registerLazySingleton<PolicyTermCubit>(() => PolicyTermCubit())
    ..registerLazySingleton<PasswordMatchCubit>(() => PasswordMatchCubit());
}

Future<void> _initMenu() async {
  serviceLocator
    ..registerLazySingleton(() => NavigationBloc())
    ..registerLazySingleton(() => ImageBloc())
    // ..registerLazySingleton(() => FormSkinBloc())
    ..registerLazySingleton(() => WebViewBloc());
}

Future<void> _initProduct() async {
  serviceLocator

    //data src
    ..registerFactory<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    //repo
    ..registerFactory<ProductRepository>(
        () => ProductRepositoryImpl(serviceLocator<ProductRemoteDataSource>(), serviceLocator<ConnectionChecker>()))
    //use case
    ..registerLazySingleton(() => GetListProducts(serviceLocator()))
    ..registerLazySingleton(() => GetProductDetail(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => ProductBloc(getProductDetail: serviceLocator()))
    ..registerLazySingleton(() => ListProductBloc(serviceLocator()))
    ..registerLazySingleton<CheckboxCartCubit>(() => CheckboxCartCubit());
}

Future<void> _initService() async {
  serviceLocator
    //data src
    ..registerFactory<ServiceRemoteDataSrc>(() => ServiceRemoteDataSrcImpl(serviceLocator<NetworkApiService>()))
    ..registerFactory<BranchRemoteDataSource>(() => BranchRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    ..registerFactory<StaffRemoteDataSource>(() => StaffRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))

    //repo
    ..registerFactory<ServiceRepository>(
        () => ServiceRepositoryImpl(serviceLocator<ServiceRemoteDataSrc>(), serviceLocator<ConnectionChecker>()))
    ..registerFactory<BranchRepository>(() => BranchRepositoryImpl(serviceLocator<BranchRemoteDataSource>()))
    ..registerFactory<StaffRepository>(() => StaffRepositoryImpl(serviceLocator<StaffRemoteDataSource>()))

    //use case
    ..registerLazySingleton(() => GetListService(serviceLocator()))
    ..registerLazySingleton(() => GetServiceDetail(serviceLocator()))
    ..registerLazySingleton(() => GetListBranches(serviceLocator()))
    ..registerLazySingleton(() => GetListStaff(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => ServiceBloc(getServiceDetail: serviceLocator()))
    ..registerLazySingleton(() => ListServiceBloc(getListService: serviceLocator()))
    ..registerLazySingleton(() => ListStaffBloc(getListStaff: serviceLocator()))
    ..registerLazySingleton(() => ListBranchesBloc(getListBranches: serviceLocator()));
}

Future<void> _initCategory() async {
  serviceLocator
    //data src
    ..registerFactory<CategoryRemoteDataSource>(() => CategoryRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    //repo
    ..registerFactory<CategoryRepository>(() => CategoryRepositoryImpl(
          serviceLocator<CategoryRemoteDataSource>(),
        ))
    //use case
    ..registerLazySingleton(() => GetListCategories(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => ListCategoryBloc(getListCategories: serviceLocator()));
}

Future<void> _initAppointment() async {
  serviceLocator
    //data src
    ..registerFactory<AppointmentRemoteDataSource>(() => AppointmentRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    //repo
    ..registerFactory<AppointmentRepository>(() => AppointmentRepositoryImpl(
          serviceLocator<AppointmentRemoteDataSource>(),
        ))
    //use case
    ..registerLazySingleton(() => GetAppointment(serviceLocator()))
    ..registerLazySingleton(() => CreateAppointment(serviceLocator()))
    ..registerLazySingleton(() => GetListAppointment(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => AppointmentBloc(getAppointment: serviceLocator(), createAppointment: serviceLocator()))
    ..registerLazySingleton(() => ListAppointmentBloc(getListAppointment: serviceLocator()));
}

Future<void> _initAiChat() async {
  serviceLocator
    //data src
    ..registerFactory<AiChatRemoteDataSource>(() => AiChatRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    //repo
    ..registerFactory<AiChatRepository>(() => AiChatRepositoryImpl(
          serviceLocator<AiChatRemoteDataSource>(),
        ))
    //use case
    ..registerLazySingleton(() => GetAiChat(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => AiChatBloc(getAiChat: serviceLocator()));
}

Future<void> _initSkinAnalysis() async {
  serviceLocator
    //data src
    ..registerFactory<SkinAnalysisRemoteDataSource>(() => SkinAnalysisRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    //repo
    ..registerFactory<SkinAnalysisRepository>(() => SkinAnalysisRepositoryImpl(
          serviceLocator<SkinAnalysisRemoteDataSource>(),
        ))

    //use case
    ..registerLazySingleton(() => SkinAnalysisViaImage(serviceLocator()))
    ..registerLazySingleton(() => SkinAnalysisViaForm(serviceLocator()))
    ..registerLazySingleton(() => GetRoutineDetail(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => SkinAnalysisBloc(skinAnalysisViaImage: serviceLocator(), skinAnalysisViaForm: serviceLocator()))
    ..registerLazySingleton(() => RoutineBloc(getRoutineDetail: serviceLocator()));
}
