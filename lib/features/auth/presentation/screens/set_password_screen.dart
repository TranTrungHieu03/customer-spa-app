import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/screens/success_screen.dart';
import 'package:spa_mobile/core/common/styles/spacing_styles.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_confirm_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/screens/login_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
              AppLocalizations.of(context)!.setPassword,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .apply(color: TColors.primary),
            ),
            const SizedBox(
              height: TSizes.sm,
            ),
            Text(
              AppLocalizations.of(context)!.setPasswordSub,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: TSizes.md,
            ),
            BlocBuilder<PasswordCubit, PasswordState>(
              builder: (context, state) {
                bool isPasswordHidden = true;

                if (state is PasswordInitial) {
                  isPasswordHidden = state.isPasswordHidden;
                } else if (state is PasswordVisibilityToggled) {
                  isPasswordHidden = state.isPasswordHidden;
                }

                return TextFormField(
                  controller: _passwordController,
                  obscureText: isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordHidden ? Iconsax.eye_slash : Iconsax.eye,
                      ),
                      onPressed: () {
                        context
                            .read<PasswordCubit>()
                            .togglePasswordVisibility();
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: TSizes.sm,
            ),
            BlocBuilder<PasswordConfirmCubit, PasswordConfirmState>(
              builder: (context, state) {
                bool isPasswordHidden = true;

                if (state is PasswordConfirmInitial) {
                  isPasswordHidden = state.isHide;
                } else if (state is PasswordConfirmToggled) {
                  isPasswordHidden = state.isHide;
                }

                return TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.confirmPass,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordHidden ? Iconsax.eye_slash : Iconsax.eye,
                      ),
                      onPressed: () {
                        context
                            .read<PasswordConfirmCubit>()
                            .togglePasswordConfirm();
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: TSizes.md,
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
                                    .successSetPass,
                                subTitle: AppLocalizations.of(context)!
                                    .successSetPassSub,
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
                  child: Text(AppLocalizations.of(context)!.submit)),
            ),
          ],
        ),
      ),
    );
  }
}
