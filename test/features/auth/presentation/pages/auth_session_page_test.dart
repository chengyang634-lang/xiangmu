import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/auth_session_cubit.dart';
import 'package:pulsedesk/features/auth/presentation/pages/auth_session_page.dart';

import '../../fakes/fake_auth_repository.dart';

void main() {
  testWidgets('navigates to home when session is authenticated', (
    tester,
  ) async {
    final cubit = AuthSessionCubit(FakeAuthRepository(storedSession: true));

    addTearDown(cubit.close);

    final router = GoRouter(
      initialLocation: '/session',
      routes: [
        GoRoute(
          path: '/session',
          builder: (context, state) {
            return BlocProvider.value(
              value: cubit,
              child: const AuthSessionPage(),
            );
          },
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return const Scaffold(
              body: Center(child: Text('Home Destination')),
            );
          },
        ),
      ],
    );

    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await cubit.checkSession();
    await tester.pumpAndSettle();

    expect(find.text('Home Destination'), findsOneWidget);
  });
  testWidgets('navigates to sign-in when session is unauthenticated', (
    tester,
  ) async {
    final cubit = AuthSessionCubit(FakeAuthRepository(storedSession: false));

    addTearDown(cubit.close);

    final router = GoRouter(
      initialLocation: '/session',
      routes: [
        GoRoute(
          path: '/session',
          builder: (context, state) {
            return BlocProvider.value(
              value: cubit,
              child: const AuthSessionPage(),
            );
          },
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) {
            return const Scaffold(
              body: Center(child: Text('Sign In Destination')),
            );
          },
        ),
      ],
    );

    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await cubit.checkSession();
    await tester.pumpAndSettle();

    expect(find.text('Sign In Destination'), findsOneWidget);
  });
}
