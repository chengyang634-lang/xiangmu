import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/cubit/sign_out_cubit.dart';
import '../../../auth/presentation/cubit/sign_out_state.dart';

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
                ElevatedButton(
                  onPressed: () {
                    context.push('/tickets');
                  },
                  child: const Text('View tickets'),
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
