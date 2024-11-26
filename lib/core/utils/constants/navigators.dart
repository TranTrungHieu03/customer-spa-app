part of 'exports_navigators.dart';

final navigatorKey = GlobalKey<NavigatorState>();

goSignUp() async {
  Navigator.push(navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const SignUpScreen()));
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
