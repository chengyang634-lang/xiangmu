import 'package:go_router/go_router.dart';
import 'package:pulsedesk/features/auth/presentation/pages/sign_in_page.dart';

final appRouter = GoRouter(
  initialLocation: '/sign-in',
  routes: [
    GoRoute(path: '/sign-in', builder: (context, state) => const SignInPage()),
  ],
);
