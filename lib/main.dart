import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:spa_mobile/core/common/cubit/user/app_user_cubit.dart';
import 'package:spa_mobile/core/themes/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_confirm_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/password_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/policy_term_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/cubit/remember_me_cubit.dart';
import 'package:spa_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:spa_mobile/init_dependencies.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
    BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
    BlocProvider(create: (_) => serviceLocator<PasswordCubit>()),
    BlocProvider(create: (_) => serviceLocator<PasswordConfirmCubit>()),
    BlocProvider(create: (_) => serviceLocator<RememberMeCubit>()),
    BlocProvider(create: (_) => serviceLocator<PolicyTermCubit>()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SPA",
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
      locale: const Locale('vi'),
      home: const LoginScreen(),
    );
  }
}
