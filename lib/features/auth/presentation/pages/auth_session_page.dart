import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/auth_session_cubit.dart';
import '../cubit/auth_session_state.dart';

class AuthSessionPage extends StatelessWidget {
  const AuthSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthSessionCubit, AuthSessionState>(
      listener: (context, state) {
        if (state.status == AuthSessionStatus.authenticated) {
          context.go('/home');
          return;
        }

        if (state.status == AuthSessionStatus.unauthenticated) {
          context.go('/sign-in');
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
