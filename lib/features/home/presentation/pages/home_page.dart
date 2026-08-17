import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/cubit/sign_out_cubit.dart';
import '../../../auth/presentation/cubit/sign_out_state.dart';
import '../../../profile/presentation/cubit/current_user_cubit.dart';
import '../../../profile/presentation/cubit/current_user_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignOutCubit, SignOutState>(
      listener: (context, state) {
        if (state.status == SignOutStatus.success) {
          context.go('/sign-in');
          return;
        }

        if (state.status == SignOutStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Sign-out failed')),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == SignOutStatus.submitting;

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('PulseDesk Home'),
                const SizedBox(height: 16),

                BlocBuilder<CurrentUserCubit, CurrentUserState>(
                  builder: (context, currentUserState) {
                    switch (currentUserState.status) {
                      case CurrentUserStatus.initial:
                      case CurrentUserStatus.loading:
                        return const CircularProgressIndicator();

                      case CurrentUserStatus.success:
                        final user = currentUserState.user;

                        if (user == null) {
                          return const Text('Current user unavailable');
                        }

                        return Column(
                          children: [
                            Text(user.displayName),
                            const SizedBox(height: 4),
                            Text(user.email),
                          ],
                        );

                      case CurrentUserStatus.failure:
                        return Column(
                          children: [
                            Text(
                              currentUserState.errorMessage ??
                                  'Failed to load current user',
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<CurrentUserCubit>()
                                    .loadCurrentUser();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        );
                    }
                  },
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          context.read<SignOutCubit>().signOut();
                        },
                  child: Text(isSubmitting ? 'Signing out...' : 'Sign out'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
