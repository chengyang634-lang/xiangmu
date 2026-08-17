import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulsedesk/core/network/api_config.dart';
import 'package:pulsedesk/features/auth/data/repositories/dio_auth_repository.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:pulsedesk/features/auth/presentation/pages/sign_in_page.dart';

final dio = Dio(BaseOptions(baseUrl: apiBaseUrl));

final authRepository = DioAuthRepository(dio);

final appRouter = GoRouter(
  initialLocation: '/sign-in',
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => SignInCubit(authRepository),
          child: const SignInPage(),
        );
      },
    ),
  ],
);
