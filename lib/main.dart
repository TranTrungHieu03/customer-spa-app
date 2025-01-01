import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:spa_mobile/core/common/cubit/user/app_user_cubit.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/provider/language_provider.dart';
import 'package:spa_mobile/core/themes/theme.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:spa_mobile/features/auth/presentation/screens/on_boarding_screen.dart';
import 'package:spa_mobile/features/home/presentation/blocs/form_skin/form_skin_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/image_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/navigation_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/list_product/list_product_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/category/list_category_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_service/list_service_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/service/service_bloc.dart';
import 'package:spa_mobile/firebase_options.dart';
import 'package:spa_mobile/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies and Firebase
  await initDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize LanguageProvider
  final languageProvider = LanguageProvider();
  await languageProvider.loadLanguage();

  // Run the app with MultiBlocProvider and LanguageProvider
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<ServiceBloc>()),
        BlocProvider(create: (_) => serviceLocator<ListServiceBloc>()),
        BlocProvider(create: (_) => serviceLocator<ListCategoryBloc>()),
        BlocProvider(create: (_) => serviceLocator<ListProductBloc>()),
        BlocProvider(create: (_) => serviceLocator<ProductBloc>()),
        BlocProvider(create: (_) => serviceLocator<ImageBloc>()),
        BlocProvider(create: (_) => serviceLocator<FormSkinBloc>()),
        BlocProvider(create: (_) => serviceLocator<NavigationBloc>()),
        BlocProvider(create: (_) => serviceLocator<AppointmentBloc>()),
      ],
      child: ChangeNotifierProvider<LanguageProvider>(
        create: (_) => languageProvider,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          key: ValueKey(languageProvider.locale),
          title: "Solace Spa",
          themeMode: ThemeMode.light,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          navigatorKey: navigatorKey,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [Locale('en'), Locale('vi')],
          locale: languageProvider.locale,
          home: FutureBuilder(
              future: _getStartScreen(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const TLoader();
                } else {
                  return const OnBoardingScreen();
                }
              }),
        );
      },
    );
  }

  Future<void> _getStartScreen(BuildContext context) async {
    final isLogin = await LocalStorage.getData(LocalStorageKey.isLogin);
    final isCompletedOnBoarding =
        await LocalStorage.getData(LocalStorageKey.isCompletedOnBoarding);
    if (isLogin == 'true') {
      goHome();
    } else if (isCompletedOnBoarding == 'true') {
      goLoginNotBack();
    } else {
      goOnboarding();
    }
  }
}
