import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'l10n/app_localizations.dart';
import 'state/auth_state.dart';
import 'state/theme_state.dart';
import 'state/locale_state.dart';
import 'state/auction_state.dart';
import 'state/parts_state.dart';
import 'state/booking_state.dart';
import 'state/admin_stats_state.dart';
import 'features/auctions/controller/auction_controller.dart';
import 'admin/auctions/controller/admin_auction_controller.dart';
import 'core/storage/storage_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe
  if (!kIsWeb && !GetPlatform.isWindows) {
    Stripe.publishableKey = AppConstants.stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  // Initialize storage service FIRST
  final storageService = StorageService();
  await storageService.init();

  // Initialize state management - Get.put will trigger onInit()
  // onInit() will synchronously restore user state from storage
  final authState = Get.put(AuthState());
  Get.put(ThemeState());
  Get.put(LocaleState());
  Get.put(AuctionState());
  Get.put(AuctionController());
  Get.put(AdminAuctionController());
  Get.put(PartsState());
  Get.put(BookingState());
  Get.put(AdminStatsState());

  // At this point, user state should already be restored from storage (in onInit)
  // Now validate/refresh the session with API if needed
  print(
    'Main: State restored, currentUser: ${authState.currentUser?.name ?? "null"}',
  );

  // Try to validate/refresh session with API (non-blocking)
  // This will update user data if API is available, but won't block if it fails
  try {
    final isLoggedIn = await authState.autoLogin();
    print(
      'Main: autoLogin validation returned: $isLoggedIn, currentUser: ${authState.currentUser?.name ?? "null"}',
    );
  } catch (e) {
    print('Main: autoLogin exception: $e');
  }

  // Run app - state is already restored, so UI will show correct data immediately
  runApp(const STOApp());
}

class STOApp extends StatelessWidget {
  const STOApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeState = Get.find<ThemeState>();
      final localeState = Get.find<LocaleState>();
      return MaterialApp.router(
        title: 'STO Car Marketplace',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeState.themeMode,
        locale: localeState.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: AppRouter.router,
      );
    });
  }
}
