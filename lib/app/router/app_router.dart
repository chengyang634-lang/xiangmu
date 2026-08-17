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

import 'package:pulsedesk/features/tickets/data/repositories/dio_ticket_repository.dart';
import 'package:pulsedesk/features/tickets/domain/repositories/ticket_repository.dart';
import 'package:pulsedesk/features/tickets/presentation/cubit/ticket_list_cubit.dart';
import 'package:pulsedesk/features/tickets/presentation/pages/ticket_list_page.dart';
import 'package:pulsedesk/features/tickets/presentation/cubit/ticket_detail_cubit.dart';
import 'package:pulsedesk/features/tickets/presentation/pages/ticket_detail_page.dart';

final publicDio = Dio(BaseOptions(baseUrl: apiBaseUrl));

const secureStorage = FlutterSecureStorage();

final authTokenStorage = SecureAuthTokenStorage(secureStorage);

final authenticatedDio = createAuthenticatedApiClient(
  baseUrl: apiBaseUrl,
  readAccessToken: authTokenStorage.readAccessToken,
);

final authRepository = DioAuthRepository(publicDio, authTokenStorage);
final ticketRepository = DioTicketRepository(authenticatedDio);
GoRouter createAppRouter({
  required AuthRepository authRepository,
  required TicketRepository ticketRepository,
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
          return BlocProvider(
            create: (context) => SignOutCubit(authRepository),
            child: const HomePage(),
          );
        },
      ),
      GoRoute(
        path: '/tickets',
        builder: (context, state) {
          return BlocProvider(
            create: (context) {
              return TicketListCubit(ticketRepository)..loadTickets();
            },
            child: const TicketListPage(),
          );
        },
      ),
      GoRoute(
        path: '/tickets/:ticketId',
        builder: (context, state) {
          final ticketId = state.pathParameters['ticketId']!;

          return BlocProvider(
            create: (context) {
              return TicketDetailCubit(ticketRepository)..loadTicket(ticketId);
            },
            child: TicketDetailPage(ticketId: ticketId),
          );
        },
      ),
    ],
  );
}

final appRouter = createAppRouter(
  authRepository: authRepository,
  ticketRepository: ticketRepository,
);
