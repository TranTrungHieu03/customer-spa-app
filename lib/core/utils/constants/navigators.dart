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

goProductDetail(int id) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => ProductDetailScreen(productId: id)));
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
  Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const NavigationMenu()), (Route<dynamic> route) => false);
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

goCheckout() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const CheckoutScreen()));
}

goShipmentInfo() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const ShipmentInformationScreen()));
}

goServiceHistory() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const ServiceHistoryScreen()));
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

goServiceDetail(int id) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => ServiceDetailScreen(
                serviceId: id,
              )));
}

goBookingDetail(int id) async {
  Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => BookingDetailScreen(bookingId: id)),
      (Route<dynamic> route) => false);
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

goServiceBooking(ServiceModel service) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => BookingServiceScreen(service: service)));
}

goServiceCheckout(ServiceModel service) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => CheckoutServiceScreen(services: [service])));
}

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

goFeedback() async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const FeedbackScreen()));
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

goWebView(String url) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => WebViewScreen(url: url)));
}

goQrCode(String id, DateTime time) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => QrCodeScreen(id: id, time: time)));
}

goCart(bool isProduct) async {
  Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => CartScreen(isProduct: isProduct)));
}

goRoutineDetail(String id) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => RoutineDetailScreen(id: id),
      ));
}
