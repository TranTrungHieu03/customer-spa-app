import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/styles/spacing_styles.dart';
import 'package:spa_mobile/core/common/widgets/form_divider.dart';
import 'package:spa_mobile/core/common/widgets/social_btn.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/core/utils/validators/validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/remember_me_cubit.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:spa_mobile/features/auth/presentation/screens/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyles.paddingWithAppbarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                height: 150,
                image: AssetImage(TImages.logo),
              ),
              Text(
                AppLocalizations.of(context)!.welcomeBack,
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineMedium!
                    .apply(color: TColors.primary),
              ),
              const SizedBox(
                height: TSizes.sm,
              ),
              Text(
                AppLocalizations.of(context)!.loginSub,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
              ),
              const SizedBox(
                height: TSizes.sm,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) => TValidator.validateEmail(value),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.direct_right),
                          labelText: AppLocalizations.of(context)!.email,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: TSizes.sm),
                      BlocBuilder<PasswordCubit, PasswordState>(
                        builder: (context, state) {
                          bool isPasswordHidden = true;

                          if (state is PasswordInitial) {
                            isPasswordHidden = state.isPasswordHidden;
                          } else if (state is PasswordVisibilityToggled) {
                            isPasswordHidden = state.isPasswordHidden;
                          }

                          return TextFormField(
                            obscureText: isPasswordHidden,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.password,
                              prefixIcon: const Icon(Iconsax.password_check),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordHidden
                                      ? Iconsax.eye_slash
                                      : Iconsax.eye,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Remember me
                          Row(
                            children: [
                              BlocBuilder<RememberMeCubit, RememberMeState>(
                                  builder: (context, state) {
                                    bool isRemember = true;
                                    if (state is RememberMeInitial) {
                                      isRemember = state.isRemember;
                                    } else if (state is RememberMeToggle) {
                                      isRemember = state.isRemember;
                                    }
                                    return Checkbox(
                                        value: isRemember,
                                        onChanged: (newValue) {
                                          context
                                              .read<RememberMeCubit>()
                                              .toggleRememberMe();
                                        });
                                  }),
                              Text(AppLocalizations.of(context)!.rememberMe),
                            ],
                          ),
                          //Forget Pass
                          TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (
                                        context) => const ForgotPasswordScreen()));
                              },
                              child: Text(
                                  AppLocalizations.of(context)!.forgetPassword))
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.spacebtwSections / 2,
                      ),
                      //sign in
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text(AppLocalizations.of(context)!.login)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dontHaveAccount,
                            style: Theme
                                .of(context)
                                .textTheme
                                .labelMedium,
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (
                                            context) => const SignUpScreen()),
                                  ),
                              child: Text(
                                AppLocalizations.of(context)!.createAccount,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelMedium!
                                    .apply(color: TColors.primary),
                              ),
                            ),
                          )
                        ],
                      ),

                      FormDivider(
                          dividerText:
                          AppLocalizations.of(context)!.signInWith),
                      const SizedBox(
                        height: TSizes.defaultSpace,
                      ),

                      const SocialBtn(),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}