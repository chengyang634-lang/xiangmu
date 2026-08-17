import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_in_state.dart';
import 'package:pulsedesk/features/auth/presentation/pages/sign_in_page.dart';

import 'features/auth/fakes/fake_auth_repository.dart';

void main() {
  testWidgets('shows required errors when sign-in form is empty', (
    tester,
  ) async {
    final authRepository = FakeAuthRepository();
    final cubit = SignInCubit(authRepository);

    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const SignInPage()),
      ),
    );

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('shows validation errors for invalid credentials', (
    tester,
  ) async {
    final authRepository = FakeAuthRepository();
    final cubit = SignInCubit(authRepository);

    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const SignInPage()),
      ),
    );

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'abc');
    await tester.enterText(fields.at(1), '123');

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
  });

  testWidgets('shows loading and disables button while submitting', (
    tester,
  ) async {
    final completer = Completer<void>();

    final authRepository = FakeAuthRepository(
      result: completer.future,
      error: Exception(),
    );

    final cubit = SignInCubit(authRepository);

    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const SignInPage()),
      ),
    );

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'user@example.com');
    await tester.enterText(fields.at(1), '12345678');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNull);

    completer.complete();

    await tester.pumpAndSettle();
  });

  testWidgets('shows sign-in failure message in a SnackBar', (tester) async {
    final authRepository = FakeAuthRepository();
    final cubit = SignInCubit(authRepository);

    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const SignInPage()),
      ),
    );

    cubit.markFailure('Invalid email or password');

    await tester.pump();

    expect(find.text('Invalid email or password'), findsOneWidget);

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('shows fallback message when sign-in failure has no message', (
    tester,
  ) async {
    final authRepository = FakeAuthRepository();
    final cubit = SignInCubit(authRepository);

    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const SignInPage()),
      ),
    );

    cubit.emit(const SignInState(status: SignInStatus.failure));

    await tester.pump();

    expect(find.text('Sign-in failed'), findsOneWidget);

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('navigates to home after successful sign-in', (tester) async {
    final authRepository = FakeAuthRepository();
    final cubit = SignInCubit(authRepository);

    addTearDown(cubit.close);

    final router = GoRouter(
      initialLocation: '/sign-in',
      routes: [
        GoRoute(
          path: '/sign-in',
          builder: (context, state) {
            return BlocProvider.value(value: cubit, child: const SignInPage());
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

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'user@example.com');

    await tester.enterText(fields.at(1), '12345678');

    await tester.tap(find.text('Sign in'));

    await tester.pumpAndSettle();

    expect(find.text('Home Destination'), findsOneWidget);
  });
}
