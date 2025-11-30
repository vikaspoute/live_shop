// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_shop/core/di/injector.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:live_shop/presentation/blocs/auth/auth_bloc.dart';
import 'package:live_shop/presentation/blocs/cart/cart_cubit.dart';
import 'package:live_shop/presentation/blocs/chat/chat_cubit.dart';
import 'package:live_shop/presentation/blocs/orders/orders_cubit.dart';
import 'package:live_shop/presentation/blocs/session/session_bloc.dart';
import 'package:live_shop/presentation/pages/login_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<SessionBloc>()),
        BlocProvider(create: (_) => getIt<ChatCubit>()),
        BlocProvider(create: (_) => getIt<CartCubit>()),
        BlocProvider(create: (_) => getIt<OrdersCubit>()),
      ],
      child: ShadApp(
        title: 'Live Shop',
        // Will be overridden by l10n in MaterialApp if needed
        themeMode: ThemeMode.light,

        // Light Theme
        theme: ShadThemeData(
          brightness: Brightness.light,
          colorScheme: const ShadZincColorScheme.light(),
        ),

        // Dark Theme
        darkTheme: ShadThemeData(
          brightness: Brightness.dark,
          colorScheme: const ShadZincColorScheme.dark(),
        ),

        // Localization Support
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: const Locale('en'),

        home: const LoginPage(),
      ),
    );
  }
}
