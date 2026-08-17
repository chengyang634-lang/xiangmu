import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'package:pulsedesk/core/network/api_config.dart';
import 'package:pulsedesk/features/auth/data/repositories/dio_auth_repository.dart';
import 'package:pulsedesk/features/auth/data/storage/secure_auth_token_storage.dart';
import 'package:pulsedesk/features/auth/domain/repositories/auth_repository.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/auth_session_cubit.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:pulsedesk/features/auth/presentation/pages/auth_session_page.dart';
import 'package:pulsedesk/features/auth/presentation/pages/sign_in_page.dart';
import 'package:pulsedesk/features/home/presentation/pages/home_page.dart';

final dio = Dio(BaseOptions(baseUrl: apiBaseUrl));

const secureStorage = FlutterSecureStorage();

final authTokenStorage = SecureAuthTokenStorage(secureStorage);

final authRepository = DioAuthRepository(dio, authTokenStorage);

GoRouter createAppRouter({required AuthRepository authRepository}) {
  return GoRouter(
    initialLocation: '/session',
    routes: [
      GoRoute(
        path: '/session',
        builder: (context, state) {
          return BlocProvider(
            create: (context) {
              return AuthSessionCubit(authRepository)..checkSession();
            },
            child: const AuthSessionPage(),
          );
        },
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => SignInCubit(authRepository),
            child: const SignInPage(),
          );
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return const HomePage();
        },
      ),
    ],
  );
}

final appRouter = createAppRouter(authRepository: authRepository);
