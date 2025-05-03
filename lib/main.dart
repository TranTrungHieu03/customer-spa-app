import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:spa_mobile/core/common/bloc/payment_payos/payos_bloc.dart';
import 'package:spa_mobile/core/common/bloc/web_view/web_view_bloc.dart';
import 'package:spa_mobile/core/common/cubit/user/app_user_cubit.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/provider/language_provider.dart';
import 'package:spa_mobile/core/services/notification.dart';
import 'package:spa_mobile/core/services/permission.dart';
import 'package:spa_mobile/core/services/signalR.dart';
import 'package:spa_mobile/core/themes/theme.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/form_skin/form_skin_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/image/image_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/routine/routine_bloc.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/blocs/skin_analysis/skin_analysis_bloc.dart';
import 'package:spa_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/presentation/blocs/ai_chat/ai_chat_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/home_state/home_state_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/list_notification/list_notification_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/navigation_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/nearest_branch/nearest_branch_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/user_chat/user_chat_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/order/order_bloc.dart';
import 'package:spa_mobile/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/appointment/appointment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_branches/list_branches_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_staff/list_staff_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/list_time/list_time_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/payment/payment_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/service/service_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/service_cart/service_cart_bloc.dart';
import 'package:spa_mobile/features/service/presentation/bloc/staff/staff_bloc.dart';
import 'package:spa_mobile/features/user/presentation/bloc/address/address_bloc.dart';
import 'package:spa_mobile/features/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:spa_mobile/firebase_options.dart';
import 'package:spa_mobile/init_dependencies.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies and Firebase
  await initDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  await PermissionService().getCurrentLocation();
  tz.initializeTimeZones();
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
        BlocProvider(create: (_) => serviceLocator<ProfileBloc>()),
        BlocProvider(create: (_) => serviceLocator<AddressBloc>()),
        BlocProvider(create: (_) => serviceLocator<UserChatBloc>()),
        BlocProvider(create: (_) => serviceLocator<ProductBloc>()),
        BlocProvider(create: (_) => serviceLocator<ImageBloc>()),
        BlocProvider(create: (_) => serviceLocator<NavigationBloc>()),
        BlocProvider(create: (_) => serviceLocator<AppointmentBloc>()),
        BlocProvider(create: (_) => serviceLocator<AiChatBloc>()),
        BlocProvider(create: (_) => serviceLocator<FormSkinBloc>()),
        BlocProvider(create: (_) => serviceLocator<WebViewBloc>()),
        BlocProvider(create: (_) => serviceLocator<ListBranchesBloc>()),
        BlocProvider(create: (_) => serviceLocator<NearestBranchBloc>()),
        BlocProvider(create: (_) => serviceLocator<ListStaffBloc>()),
        BlocProvider(create: (_) => serviceLocator<SkinAnalysisBloc>()),
        BlocProvider(create: (_) => serviceLocator<RoutineBloc>()),
        BlocProvider(create: (_) => serviceLocator<ListTimeBloc>()),
        BlocProvider(create: (_) => serviceLocator<PaymentBloc>()),
        BlocProvider(create: (_) => serviceLocator<PayosBloc>()),
        BlocProvider(create: (_) => serviceLocator<StaffBloc>()),
        BlocProvider(create: (_) => serviceLocator<ServiceCartBloc>()),
        BlocProvider(create: (_) => serviceLocator<CartBloc>()),
        BlocProvider(create: (_) => serviceLocator<OrderBloc>()),
        BlocProvider(create: (_) => serviceLocator<ListNotificationBloc>()),
        BlocProvider(create: (_) => serviceLocator<HomeStateBloc>()),
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<UserChatBloc>().stream.listen((state) {
      if (state is UserChatLoaded) {
        SignalRService.initialize(state.user.id);
      } else if (state is UserChatError) {
        AppLogger.wtf("signal R disconnect");
        SignalRService.disconnect();
      }
    });
    context.read<AuthBloc>().stream.listen((state) {
      if (state is AuthFailure || state is AuthClear) {
        AppLogger.wtf("signal R disconnect");
        SignalRService.disconnect();
      }
    });
    if (context.read<UserChatBloc>().state is UserChatInitial) {
      AppLogger.wtf("Init signalR init");
      _loadUserChat();
    }
  }

  void _loadUserChat() async {
    final jsonUserChat = await LocalStorage.getData(LocalStorageKey.userChat);
    if (jsonUserChat.isNotEmpty) {
      final user = UserChatModel.fromJson(jsonDecode(jsonUserChat));
      SignalRService.initialize(user.id);
      AppLogger.wtf("Init signalR");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final state = context.read<UserChatBloc>().state;
      if (state is UserChatLoaded) {
        SignalRService.initialize(state.user.id);
      } else {
        _loadUserChat();
      }
    } else if (state == AppLifecycleState.detached) {
      SignalRService.disconnect();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
              return const TLoader();
            },
          ),
        );
      },
    );
  }

  Future<void> _getStartScreen(BuildContext context) async {
    final isLogin = await LocalStorage.getData(LocalStorageKey.isLogin);
    final isCompletedOnBoarding = await LocalStorage.getData(LocalStorageKey.isCompletedOnBoarding);
    if (isLogin == 'true') {
      goHome();
    } else if (isCompletedOnBoarding == 'true') {
      goLoginNotBack();
    } else {
      goOnboarding();
    }
  }
}
