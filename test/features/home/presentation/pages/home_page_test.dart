import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_out_cubit.dart';
import 'package:pulsedesk/features/home/presentation/pages/home_page.dart';

import '../../../auth/fakes/fake_auth_repository.dart';

void main() {
  testWidgets('navigates to sign-in when sign-out succeeds', (tester) async {
    final authRepository = FakeAuthRepository();

    final signOutCubit = SignOutCubit(authRepository);

    addTearDown(signOutCubit.close);

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return BlocProvider.value(
              value: signOutCubit,
              child: const HomePage(),
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

    expect(find.text('PulseDesk Home'), findsOneWidget);

    expect(find.text('Sign out'), findsOneWidget);

    await tester.tap(find.text('Sign out'));

    await tester.pumpAndSettle();

    expect(authRepository.signOutCalled, isTrue);

    expect(find.text('Sign In Destination'), findsOneWidget);
  });
  testWidgets('stays on home and shows error when sign-out fails', (
    tester,
  ) async {
    final authRepository = FakeAuthRepository(
      signOutError: Exception('storage failed'),
    );

    final signOutCubit = SignOutCubit(authRepository);

    addTearDown(signOutCubit.close);

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return BlocProvider.value(
              value: signOutCubit,
              child: const HomePage(),
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

    await tester.tap(find.text('Sign out'));

    await tester.pumpAndSettle();

    expect(authRepository.signOutCalled, isTrue);

    expect(find.text('PulseDesk Home'), findsOneWidget);

    expect(find.text('Sign-out failed'), findsOneWidget);

    expect(find.text('Sign In Destination'), findsNothing);
  });
  testWidgets('disables sign-out button while sign-out is submitting', (
    tester,
  ) async {
    final completer = Completer<void>();

    final authRepository = FakeAuthRepository(signOutResult: completer.future);

    final signOutCubit = SignOutCubit(authRepository);

    addTearDown(signOutCubit.close);

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return BlocProvider.value(
              value: signOutCubit,
              child: const HomePage(),
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

    await tester.tap(find.text('Sign out'));

    await tester.pump();

    expect(find.text('Signing out...'), findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNull);

    completer.complete();

    await tester.pumpAndSettle();

    expect(find.text('Sign In Destination'), findsOneWidget);
  });
}
