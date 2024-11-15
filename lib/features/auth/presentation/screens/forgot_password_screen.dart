import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/styles/spacing_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/validators/validation.dart';
import 'package:spa_mobile/features/auth/presentation/screens/set_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: TSpacingStyles.paddingWithAppbarHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.forgotPasswordTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .apply(color: TColors.primary),
            ),
            const SizedBox(
              height: TSizes.sm,
            ),
            Text(
              AppLocalizations.of(context)!.forgotPasswordSub,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: TSizes.md,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) => TValidator.validateEmail(value),
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: AppLocalizations.of(context)!.email,
              ),
            ),
            const SizedBox(
              height: TSizes.md,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SetPasswordScreen(
                                email: _emailController.text
                                    .toString()
                                    .trim())));
                  },
                  child: Text(
                      AppLocalizations.of(context)!.send)),
            ),
          ],
        ),
      ),
    );
  }
}
