import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/screens/success_screen.dart';
import 'package:spa_mobile/core/common/widgets/otp_field.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/features/auth/presentation/screens/login_screen.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _pin1Controller = TextEditingController();
  final _pin2Controller = TextEditingController();
  final _pin3Controller = TextEditingController();
  final _pin4Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.verifyTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spacebtwItems,
              ),
              Text(
                widget.email ?? "",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TSizes.spacebtwItems,
              ),
              Text(
                AppLocalizations.of(context)!.verifySubTitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: TSizes.spacebtwSections,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: OTPFields(
                  pin1: _pin1Controller,
                  pin2: _pin2Controller,
                  pin3: _pin3Controller,
                  pin4: _pin4Controller,
                ),
              ),
              const SizedBox(
                height: TSizes.spacebtwSections,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuccessScreen(
                                  image: TImages.success,
                                  title: AppLocalizations.of(context)!
                                      .signUpSuccess,
                                  subTitle: AppLocalizations.of(context)!
                                      .signUpSuccessSub,
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                        (Route<dynamic> route) => false);
                                  })),
                          (Route<dynamic> route) => false);
                    },
                    child: Text(AppLocalizations.of(context)!.verify)),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () => {},
                    child: Text(AppLocalizations.of(context)!.resend))
              ])
            ],
          ),
        ),
      ),
    );
  }
}
