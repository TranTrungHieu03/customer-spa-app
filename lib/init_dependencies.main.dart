part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());
  serviceLocator.registerLazySingleton<NetworkApiService>(
      () => NetworkApiService(baseUrl: "https://solaceapi.ddnsking.com/api", authService: serviceLocator<AuthService>()));
  serviceLocator.registerLazySingleton<GoongApiService>(
      () => GoongApiService(baseUrl: "https://rsapi.goong.io/", key: "58y8peA3QXjke7sqZK4DYCiaRvcCbh6Jaffw5qCI"));
  serviceLocator.registerLazySingleton<GhnApiService>(
      () => GhnApiService(baseUrl: "https://online-gateway.ghn.vn/", token: "e79a5ca7-014e-11f0-a9a7-7e45b9a2ff31", shopId: "3838500"));

  //on boarding
  serviceLocator.registerLazySingleton(() => OnboardingBloc());

  //storage
  serviceLocator.registerLazySingleton<LocalStorage>(() => LocalStorage());
  //internet
  serviceLocator.registerFactory(() => InternetConnection());
//permissions
  serviceLocator.registerLazySingleton(() => PermissionService());
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
    ..registerFactory<GHNRemoteDataSource>(() => GHNRemoteDataSourceImpl(serviceLocator()))
    //repository
    ..registerFactory<AuthRepository>(() =>
        AuthRepositoryImpl(serviceLocator<AuthRemoteDataSource>(), serviceLocator<ConnectionChecker>(), serviceLocator<AuthService>()))
    ..registerFactory<GHNRepository>(() => GHNRepositoryImpl(serviceLocator<GHNRemoteDataSource>()))
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
    ..registerFactory(() => UpdateProfile(serviceLocator()))
    ..registerFactory(() => GetProvince(serviceLocator()))
    ..registerFactory(() => GetDistrict(serviceLocator()))
    ..registerFactory(() => GetWard(serviceLocator()))
    ..registerFactory(() => GetFeeShipping(serviceLocator()))

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
    ..registerLazySingleton(() => ProfileBloc(
          getDistrict: serviceLocator(),
          updateProfile: serviceLocator(),
          getUserInformation: serviceLocator(),
          getProvince: serviceLocator(),
          getWard: serviceLocator(),
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
    ..registerLazySingleton(() => PaymentBloc(payFull: serviceLocator(), payDeposit: serviceLocator()))
    ..registerLazySingleton(() => PayosBloc())
    ..registerLazySingleton(() => ServiceCartBloc())
    ..registerLazySingleton(() => WebViewBloc())
    //usecase
    ..registerLazySingleton(() => PayDeposit(serviceLocator()))
    ..registerLazySingleton(() => PayFull(serviceLocator()));
}

Future<void> _initProduct() async {
  serviceLocator

    //data src
    ..registerFactory<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    ..registerFactory<CartRemoteDataSource>(() => CartRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    ..registerFactory<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    ..registerFactory<LocationRemoteDataSource>(() => LocationRemoteDataSourceImpl(
          serviceLocator<PermissionService>(),
          serviceLocator<GoongApiService>(),
        ))
    //repo
    ..registerFactory<ProductRepository>(
        () => ProductRepositoryImpl(serviceLocator<ProductRemoteDataSource>(), serviceLocator<ConnectionChecker>()))
    ..registerFactory<CartRepository>(() => CartRepositoryImpl(serviceLocator<CartRemoteDataSource>()))
    ..registerFactory<LocationRepository>(() => LocationRepositoryImpl(serviceLocator<LocationRemoteDataSource>()))
    ..registerFactory<OrderRepository>(() => OrderRepositoryImpl(serviceLocator<OrderRemoteDataSource>()))
    //use case
    ..registerLazySingleton(() => GetListProducts(serviceLocator()))
    ..registerLazySingleton(() => GetProductDetail(serviceLocator()))
    ..registerLazySingleton(() => GetCart(serviceLocator()))
    ..registerLazySingleton(() => AddProductCart(serviceLocator()))
    ..registerLazySingleton(() => RemoveProductCart(serviceLocator()))
    ..registerLazySingleton(() => GetDistance(serviceLocator()))
    ..registerLazySingleton(() => GetAddressAutoComplete(serviceLocator()))
    ..registerLazySingleton(() => CreateOrder(serviceLocator()))
    ..registerLazySingleton(() => GetAvailableService(serviceLocator()))
    ..registerLazySingleton(() => GetLeadTime(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => ProductBloc(getProductDetail: serviceLocator()))
    ..registerLazySingleton(() => OrderBloc(createOrder: serviceLocator()))
    ..registerLazySingleton(() => ListProductBloc(getListProducts: serviceLocator()))
    ..registerLazySingleton(() => NearestBranchBloc(getDistance: serviceLocator()))
    ..registerLazySingleton(
        () => ShipFeeBloc(getLeadTime: serviceLocator(), getFeeShipping: serviceLocator(), getAvailableService: serviceLocator()))
    ..registerLazySingleton(() => AddressBloc(
        addressAutoComplete: serviceLocator(), getDistrict: serviceLocator(), getWard: serviceLocator(), getProvince: serviceLocator()))
    ..registerLazySingleton(
        () => CartBloc(addProductCart: serviceLocator(), getProductCart: serviceLocator(), removeProductCart: serviceLocator()))
    ..registerLazySingleton<CheckboxCartCubit>(() => CheckboxCartCubit([]));
}

Future<void> _initService() async {
  serviceLocator
    //data src
    ..registerFactory<ServiceRemoteDataSrc>(() => ServiceRemoteDataSrcImpl(serviceLocator<NetworkApiService>()))
    ..registerFactory<BranchRemoteDataSource>(() => BranchRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    ..registerFactory<StaffRemoteDataSource>(() => StaffRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    ..registerFactory<HubRemoteDataSource>(() => HubRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))

    //repo
    ..registerFactory<ServiceRepository>(
        () => ServiceRepositoryImpl(serviceLocator<ServiceRemoteDataSrc>(), serviceLocator<ConnectionChecker>()))
    ..registerFactory<BranchRepository>(() => BranchRepositoryImpl(serviceLocator<BranchRemoteDataSource>()))
    ..registerFactory<StaffRepository>(() => StaffRepositoryImpl(serviceLocator<StaffRemoteDataSource>()))
    ..registerFactory<HubRepository>(() => HubRepositoryImpl(serviceLocator<HubRemoteDataSource>()))

    //use case
    ..registerLazySingleton(() => GetListService(serviceLocator()))
    ..registerLazySingleton(() => GetServiceDetail(serviceLocator()))
    ..registerLazySingleton(() => GetListBranches(serviceLocator()))
    ..registerLazySingleton(() => GetListStaff(serviceLocator()))
    ..registerLazySingleton(() => GetSingleStaff(serviceLocator()))
    ..registerLazySingleton(() => GetStaffFreeInTime(serviceLocator()))
    ..registerLazySingleton(() => GetBranchDetail(serviceLocator()))
    ..registerLazySingleton(() => GetUserChatInfo(serviceLocator()))
    ..registerLazySingleton(() => GetListChannel(serviceLocator()))
    ..registerLazySingleton(() => GetChannel(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => ServiceBloc(getServiceDetail: serviceLocator()))
    ..registerLazySingleton(() => ListServiceBloc(getListService: serviceLocator()))
    ..registerLazySingleton(() => BranchBloc(getBranchDetail: serviceLocator()))
    ..registerLazySingleton(() => UserChatBloc(getUserChatInfo: serviceLocator()))
    ..registerLazySingleton(() => ListChannelBloc(getListChannel: serviceLocator()))
    ..registerLazySingleton(() => ChannelBloc(getChannel: serviceLocator()))
    ..registerLazySingleton(() => StaffBloc(getSingleStaff: serviceLocator()))
    ..registerLazySingleton(() => ListStaffBloc(getListStaff: serviceLocator(), getStaffFreeInTime: serviceLocator()))
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
    ..registerLazySingleton(() => GetTimeSlotByDate(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => AppointmentBloc(getAppointment: serviceLocator(), createAppointment: serviceLocator()))
    ..registerLazySingleton(() => ListAppointmentBloc(getListAppointment: serviceLocator()))
    ..registerLazySingleton(() => ListTimeBloc(getTimeSlotByDate: serviceLocator()));
}

Future<void> _initAiChat() async {
  serviceLocator
    //data src
    ..registerFactory<AiChatRemoteDataSource>(() => AiChatRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    ..registerFactory<ChatRemoteDataSource>(() => SignalRChatRemoteDataSource(hubUrl: "https://solaceapi.ddnsking.com/chat"))
    //repo
    ..registerFactory<AiChatRepository>(() => AiChatRepositoryImpl(
          serviceLocator<AiChatRemoteDataSource>(),
        ))
    ..registerFactory<ChatRepository>(() => ChatRepositoryImpl(
          serviceLocator<ChatRemoteDataSource>(),
        ))
    //use case
    ..registerLazySingleton(() => GetAiChat(serviceLocator()))
    ..registerLazySingleton(() => SendMessage(serviceLocator()))
    ..registerLazySingleton(() => ConnectHub(serviceLocator()))
    ..registerLazySingleton(() => DisconnectHub(serviceLocator()))
    ..registerLazySingleton(() => GetMessages(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => AiChatBloc(getAiChat: serviceLocator()))
    ..registerLazySingleton(() => ChatBloc(
          getMessages: serviceLocator(),
          sendMessage: serviceLocator(),
          connect: serviceLocator(),
          disconnect: serviceLocator(),
        ));
}

Future<void> _initSkinAnalysis() async {
  serviceLocator
    //data src
    ..registerFactory<SkinAnalysisRemoteDataSource>(() => SkinAnalysisRemoteDataSourceImpl(serviceLocator<NetworkApiService>()))
    ..registerFactory<RoutineRemoteDataSource>(() => RoutineRemoteDateSourceImpl(serviceLocator<NetworkApiService>()))
    //repo
    ..registerFactory<SkinAnalysisRepository>(() => SkinAnalysisRepositoryImpl(
          serviceLocator<SkinAnalysisRemoteDataSource>(),
        ))
    ..registerFactory<RoutineRepository>(() => RoutineRepositoryImpl(
          serviceLocator<RoutineRemoteDataSource>(),
        ))

    //use case
    ..registerLazySingleton(() => SkinAnalysisViaImage(serviceLocator()))
    ..registerLazySingleton(() => SkinAnalysisViaForm(serviceLocator()))
    ..registerLazySingleton(() => GetRoutineDetail(serviceLocator()))
    ..registerLazySingleton(() => GetListRoutine(serviceLocator()))
    ..registerLazySingleton(() => GetRoutineStep(serviceLocator()))
    ..registerLazySingleton(() => GetCurrentRoutine(serviceLocator()))
    ..registerLazySingleton(() => GetRoutineTracking(serviceLocator()))
    ..registerLazySingleton(() => BookRoutine(serviceLocator()))
    ..registerLazySingleton(() => GetListMessage(serviceLocator()))

    //bloc
    ..registerLazySingleton(() => SkinAnalysisBloc(skinAnalysisViaImage: serviceLocator(), skinAnalysisViaForm: serviceLocator()))
    ..registerLazySingleton(() => ListRoutineBloc(getListRoutine: serviceLocator()))
    ..registerLazySingleton(() => ListMessageBloc(getListMessage: serviceLocator()))
    ..registerLazySingleton(() => ListRoutineStepBloc(getRoutineStep: serviceLocator()))
    ..registerLazySingleton(() => RoutineTrackingBloc(getRoutineTracking: serviceLocator()))
    ..registerLazySingleton(() => RoutineBloc(
          getRoutineDetail: serviceLocator(),
          bookRoutine: serviceLocator(),
          getCurrentRoutine: serviceLocator(),
        ));
}
