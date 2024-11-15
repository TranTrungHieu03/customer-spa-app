import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/utils/validators/validation.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_confirm_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/policy_term_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/screens/verify_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.signUpTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .apply(color: TColors.primary),
              ),
              const SizedBox(
                height: TSizes.sm,
              ),
              Text(
                AppLocalizations.of(context)!.signUpSub,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: TSizes.md,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) => TValidator.validateEmail(value),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: AppLocalizations.of(context)!.email,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: TSizes.sm),
                      TextFormField(
                        controller: _usernameController,
                        validator: (value) => TValidator.validateEmail(value),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.user_edit),
                          labelText: AppLocalizations.of(context)!.username,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: TSizes.sm),
                      TextFormField(
                        controller: _phoneController,
                        validator: (value) => TValidator.validateEmail(value),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.call),
                          labelText: AppLocalizations.of(context)!.phone,
                        ),
                        keyboardType: TextInputType.phone,
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
                        width: TSizes.spacebtwItems,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocBuilder<PolicyTermCubit, PolicyTermState>(
                              builder: (context, state) {
                            bool isAccept = true;
                            if (state is PolicyTermInitial) {
                              isAccept = state.isAccept;
                            } else if (state is PolicyTermToggled) {
                              isAccept = state.isAccept;
                            }
                            return Checkbox(
                                value: isAccept,
                                onChanged: (newValue) {
                                  context
                                      .read<PolicyTermCubit>()
                                      .togglePolicyTerm();
                                });
                          }),
                          Expanded(
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                    text:
                                        AppLocalizations.of(context)!.iAgreeTo,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .privacyPolicy,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(
                                            color: dark
                                                ? TColors.white
                                                : TColors.primary,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: dark
                                                ? TColors.white
                                                : TColors.primary),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (_) {
                                              return Container(
                                                padding: const EdgeInsets.all(
                                                    TSizes.defaultSpace),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(AppLocalizations.of(
                                                            context)!
                                                        .privacyPolicy),
                                                    Text(AppLocalizations.of(
                                                            context)!
                                                        .privacyDetail),
                                                  ],
                                                ),
                                              );
                                            });
                                      }),
                                TextSpan(
                                    text: AppLocalizations.of(context)!.and,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .termOfUse,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(
                                            color: dark
                                                ? TColors.white
                                                : TColors.primary,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: dark
                                                ? TColors.white
                                                : TColors.primary),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (_) {
                                              return Container(
                                                padding: const EdgeInsets.all(
                                                    TSizes.defaultSpace),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(AppLocalizations.of(
                                                            context)!
                                                        .termOfUse),
                                                    Text(AppLocalizations.of(
                                                            context)!
                                                        .termOfUseDetail),
                                                  ],
                                                ),
                                              );
                                            });
                                      }),
                              ]),
                              softWrap: true,
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.spacebtwSections / 2,
                      ),
                      //sign in
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VerifyScreen(
                                          email: _emailController.text
                                              .toString()
                                              .trim())));
                            },
                            child: Text(
                                AppLocalizations.of(context)!.createAccount)),
                      ),
                      const SizedBox(
                        width: TSizes.spacebtwItems,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
