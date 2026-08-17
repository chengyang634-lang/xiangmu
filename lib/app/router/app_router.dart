import 'package:go_router/go_router.dart';
import 'package:pulsedesk/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_in_cubit.dart';

final appRouter = GoRouter(
  initialLocation: '/sign-in',
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => SignInCubit(),
          child: const SignInPage(),
        );
      },
    ),
  ],
);
