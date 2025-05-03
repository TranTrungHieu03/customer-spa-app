part of 'exports_navigators.dart';

final navigatorKey = GlobalKey<NavigatorState>();

goSignUp() async {
  Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => serviceLocator<PasswordCubit>()),
                  BlocProvider(create: (_) => serviceLocator<PasswordConfirmCubit>()),
                  BlocProvider(create: (_) => serviceLocator<PolicyTermCubit>()),
                  BlocProvider(create: (_) => serviceLocator<PasswordMatchCubit>()),
                ],
                child: const SignUpScreen(),
              )),
      (Route<dynamic> route) => false);
}

goForgotPassword() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
}

goSetting() async {
  navigatorKey.currentContext!.read<NavigationBloc>().add(ChangeSelectedIndexEvent(3));
  Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const NavigationMenu()), (Route<dynamic> route) => false);
}

goProductDetail(int id, PurchasingDataController controller) async {
  Navigator.push(
      navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => ProductDetailScreen(productId: id, controller: controller)));
}

goSetPassword(String email) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => serviceLocator<PasswordCubit>()),
                  BlocProvider(create: (_) => serviceLocator<PasswordConfirmCubit>()),
                  BlocProvider(create: (_) => serviceLocator<PasswordMatchCubit>()),
                ],
                child: SetPasswordScreen(email: email),
              )));
}

goHome() async {
  navigatorKey.currentContext!.read<NavigationBloc>().add(ChangeSelectedIndexEvent(0));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const NavigationMenu()), (Route<dynamic> route) => false);
  });
}

goLogin() async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => serviceLocator<PasswordCubit>()),
                  BlocProvider(create: (_) => serviceLocator<RememberMeCubit>()),
                ],
                child: const LoginScreen(),
              )));
}

goLoginNotBack() async {
  Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => MultiBlocProvider(providers: [
                BlocProvider(create: (_) => serviceLocator<PasswordCubit>()),
                BlocProvider(create: (_) => serviceLocator<RememberMeCubit>()),
              ], child: const LoginScreen())),
      (Route<dynamic> route) => false);
}

goCheckout(PurchasingDataController controller) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => CheckoutScreen(controller: controller)));
}

goShipmentInfo(PurchasingDataController controller) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => ShipmentInformationScreen(
                controller: controller,
              )));
}

goServiceHistory() async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => BlocProvider<ListAppointmentBloc>(
                create: (_) => ListAppointmentBloc(getListAppointment: serviceLocator(), getAppointmentsByRoutine: serviceLocator()),
                child: const ServiceHistoryScreen(),
              )));
}

goSearch() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const SearchScreen()));
}

goHistory() async {
  Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const HistoryScreen()), (Route<dynamic> route) => false);
}

goProfile() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const ProfileScreen()));
}

// goServiceDetail(int id) async {
//   Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//           builder: (context) => ServiceDetailScreen(
//                 serviceId: id,
//
//               )));
// }

goServiceDetailBooking(int id, int branchId, AppointmentDataController controller) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => ServiceDetailScreen(
                serviceId: id,
                branchId: branchId,
                controller: controller,
              )));
}

goBookingDetail(int id, {bool isBack = false}) async {
  Navigator.push(
    navigatorKey.currentContext!,
    MaterialPageRoute(builder: (context) => PaymentScreen(id: id, isBack: isBack)),
  );
}

goSuccess(String title, String subTitle, VoidCallback onPressed, String image) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => SuccessScreen(
                title: title,
                subTitle: subTitle,
                onPressed: onPressed,
                image: image,
              )));
}
//
// goServiceCheckout(List<ServiceModel> services) async {
//   Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => CheckoutServiceScreen(services: services)));
// }

goVerify(String email, int statePage) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => VerifyScreen(
                email: email,
                statePage: statePage,
              )));
}

goChat() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const ChatAiScreen()));
}

goFeedback(int customerId, int serviceId, int orderId) async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => ServiceFeedbackScreen(customerId: customerId, serviceId: serviceId, orderId: orderId)));
}

goStatusService(String title, String content, Widget value, String image, Color color) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => StatusServiceScreen(title: title, content: content, value: value, image: image, color: color)));
}

goImageReview(File image) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => BasicScreenImage(
                image: image,
              )));
}

goFormData(SkinHealthModel skinHealth, bool isFromAI) async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => WrapperFormCollectData(skinHealth: skinHealth, isFromAI: isFromAI)));
}

goOnboarding() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
}

goSkinAnalysing(File imagePath) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => WrapperAnalysingImageScreen(imagePath: imagePath)));
}

goSkinResult() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const AnalysisResultScreen()));
}

goWebPayment(String url, int id) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => PaymentWebViewPage(url: url, id: id)));
}

goRedirectPayment(int id) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => RedirectScreen(id: id)));
}

goCart(PurchasingDataController controller) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => CartScreen(controller: controller)));
}

goRoutineDetail(String id) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => WrapperRoutineDetail(id: id),
      ));
}

goShowRoutineDetail(String id) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => WrapperRoutineDetail(id: id, onlyShown: true),
      ));
}

goTrackingRoutineDetail(int id, int userId, int orderId) async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => WrapperTrackingRoutineScreen(id: id, userId: userId, orderId: orderId)));
}

goSelectTime(List<int> staffIds, AppointmentDataController controller, int indexTime) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => StaffSlotWorkingBloc(getListSlotWorking: serviceLocator()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        ListAppointmentBloc(getListAppointment: serviceLocator(), getAppointmentsByRoutine: serviceLocator()),
                  ),
                ],
                child: SelectTimeScreen(
                  staffIds: staffIds,
                  controller: controller,
                  indexTime: indexTime,
                ),
              )));
}

goUpdateTime(List<int> staffIds, AppointmentDataController controller) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => StaffSlotWorkingBloc(getListSlotWorking: serviceLocator()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        ListAppointmentBloc(getListAppointment: serviceLocator(), getAppointmentsByRoutine: serviceLocator()),
                  ),
                ],
                child: UpdateTimeScreen(
                  staffIds: staffIds,
                  controller: controller,
                ),
              )));
}

goSelectSpecialist(int branchId, AppointmentDataController controller, int isBack) async {
  AppLogger.wtf(isBack);
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => SelectSpecialistScreen(branchId: branchId, controller: controller, isBack: isBack)));
}

goUpdateSpecialist(int branchId, AppointmentDataController controller) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => UpdateSpecialistScreen(
                branchId: branchId,
                controller: controller,
              )));
}

goReview(AppointmentDataController controller) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => ConfirmPaymentScreen(
                controller: controller,
              )));
}

goUpdateReview(AppointmentDataController controller) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => ReviewUpdateScreen(
                controller: controller,
              )));
}

goSelectServices() async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => BlocProvider<ListCategoryBloc>(
                create: (_) => ListCategoryBloc(getListCategories: serviceLocator()),
                child: const SelectServiceScreen(),
              )));
}

goChatList() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => WrapperChatListScreen()));
}

goCustomize(MixDataController controller) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => CustomizeRoutineScreen(controller: controller)));
}

goUpdateStaffMix(MixDataController controller, int branchId, int isBack) async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => UpdateAppointmentsScreen(controller: controller, branchId: branchId, isBack: isBack)));
}

goUpdateTimeMix(MixDataController controller, List<int> staffIds, int index) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => StaffSlotWorkingBloc(getListSlotWorking: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          ListAppointmentBloc(getListAppointment: serviceLocator(), getAppointmentsByRoutine: serviceLocator()),
                    ),
                  ],
                  child: UpdateAppointmentsTimeScreen(
                    controller: controller,
                    staffIds: staffIds,
                    indexOfAppointment: index,
                  ))));
}

goRoutines() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => WrapperRoutineScreen()));
}

goReviewChangeRoutine(MixDataController controller) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => BlocProvider<MixBloc>(
              create: (context) => MixBloc(orderMix: serviceLocator()), child: ConfirmCustomizeScreen(controller: controller))));
}

goRoutineStep(int id) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => WrapperBookRoutineScreen(id: id)));
}

goCheckoutRoutine(RoutineDataController controller) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => CheckoutRoutineScreen(controller: controller)));
}

goSelectRoutineTime(RoutineDataController routine) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ListAppointmentBloc(getListAppointment: serviceLocator(), getAppointmentsByRoutine: serviceLocator()),
                child: SelectRoutineTimeScreen(
                  controller: routine,
                ),
              )));
}

goChatRoom(String channelId, String userId) async {
  Navigator.push(
      navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => WrapperChatRoom(channelId: channelId, userId: userId)));
}

goOrderProductDetail(int orderId) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => OrderDetailScreen(orderId: orderId)));
}

// goHistoryRoutine() async {
//   Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//           builder: (context) => BlocProvider<ListRoutineBloc>(
//                 create: (context) => ListRoutineBloc(getListRoutine: serviceLocator(), getHistoryRoutine: serviceLocator()),
//                 child: RoutineHistoryScreen(),
//               )));
// }

goFeedbackProduct(int customerId, int productId, int orderId) async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => ProductFeedbackScreen(customerId: customerId, productId: productId, orderId: orderId)));
}

goHistoryOrderRoutine() async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => BlocProvider<ListOrderRoutineBloc>(
                create: (context) => ListOrderRoutineBloc(getHistoryOrderRoutine: serviceLocator()),
                child: RoutineHistoryScreen(),
              )));
}

goOrderRoutineDetail(int orderId) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => OrderRoutineDetail(orderId: orderId)));
}

goTableAppointments() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => TableAppointmentsScreen()));
}

goAppointmentDetail(String appointmentId, bool isUpdateAll) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => AppointmentDetailScreen(
                appointmentId: (appointmentId),
                isEnableUpdateAll: isUpdateAll,
              )));
}

goOrderMixDetail(int id) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => OrderProductServiceDetailScreen(id: id)));
}

goNotification(int userId) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => BlocProvider<NotificationBloc>(
              create: (context) => NotificationBloc(markAsRead: serviceLocator(), markAsReadAll: serviceLocator()),
              child: NotificationScreen(
                userId: userId,
              ))));
}
