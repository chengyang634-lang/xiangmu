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
import 'package:pulsedesk/features/auth/presentation/cubit/sign_out_cubit.dart';
import 'package:pulsedesk/core/network/authenticated_api_client.dart';
import 'package:pulsedesk/features/profile/data/repositories/dio_current_user_repository.dart';
import 'package:pulsedesk/features/profile/domain/repositories/current_user_repository.dart';
import 'package:pulsedesk/features/profile/presentation/cubit/current_user_cubit.dart';

final publicDio = Dio(BaseOptions(baseUrl: apiBaseUrl));

const secureStorage = FlutterSecureStorage();

final authTokenStorage = SecureAuthTokenStorage(secureStorage);

final authenticatedDio = createAuthenticatedApiClient(
  baseUrl: apiBaseUrl,
  readAccessToken: authTokenStorage.readAccessToken,
);

final authRepository = DioAuthRepository(publicDio, authTokenStorage);
final currentUserRepository = DioCurrentUserRepository(authenticatedDio);
GoRouter createAppRouter({
  required AuthRepository authRepository,
  required CurrentUserRepository currentUserRepository,
}) {
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
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => SignOutCubit(authRepository)),
              BlocProvider(
                create: (context) {
                  return CurrentUserCubit(currentUserRepository)
                    ..loadCurrentUser();
                },
              ),
            ],
            child: const HomePage(),
          );
        },
      ),
    ],
  );
}

final appRouter = createAppRouter(
  authRepository: authRepository,
  currentUserRepository: currentUserRepository,
);
