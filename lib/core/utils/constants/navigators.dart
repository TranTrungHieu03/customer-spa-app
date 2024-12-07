part of 'exports_navigators.dart';

final navigatorKey = GlobalKey<NavigatorState>();

goSignUp() async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => serviceLocator<PasswordCubit>()),
                  BlocProvider(
                      create: (_) => serviceLocator<PasswordConfirmCubit>()),
                  BlocProvider(
                      create: (_) => serviceLocator<PolicyTermCubit>()),
                ],
                child: const SignUpScreen(),
              )));
}

goForgotPassword() async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
}

goProductDetail(String id) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => ProductDetailScreen(productId: id)));
}

goBookingDetail(String id) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => BookingDetailScreen(bookingId: id)));
}

goCart() async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const MyCartScreen()));
}

goHome() async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const NavigationMenu()));
}

goLogin() async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => serviceLocator<PasswordCubit>()),
                  BlocProvider(
                      create: (_) => serviceLocator<RememberMeCubit>()),
                ],
                child: const LoginScreen(),
              )));
}

goCheckout() async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const CheckoutScreen()));
}

goShipmentInfo() async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => const ShipmentInformationScreen()));
}

goServiceHistory() async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const ServiceHistoryScreen()));
}

goSearch() async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const SearchScreen()));
}

goHistory() async {
  Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
      (Route<dynamic> route) => false);
}

goProfile() async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const ProfileScreen()));
}

goServiceDetail(String id) async {
  Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => ServiceDetailScreen(
                serviceId: id,
              )));
}

goSuccess(
    String title, String subTitle, VoidCallback onPressed, String image) async {
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

goServiceBooking() async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const BookingServiceScreen()));
}

goServiceCheckout() async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const CheckoutServiceScreen()));
}
