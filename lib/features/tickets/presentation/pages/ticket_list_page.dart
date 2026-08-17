import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ticket.dart';
import '../cubit/ticket_list_cubit.dart';
import '../cubit/ticket_list_state.dart';
import 'package:go_router/go_router.dart';

class TicketListPage extends StatelessWidget {
  const TicketListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tickets')),
      body: BlocBuilder<TicketListCubit, TicketListState>(
        builder: (context, state) {
          switch (state.status) {
            case TicketListStatus.initial:
            case TicketListStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case TicketListStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage ?? 'Failed to load tickets'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TicketListCubit>().loadTickets();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );

            case TicketListStatus.success:
              if (state.tickets.isEmpty) {
                return const Center(child: Text('No tickets'));
              }

              return RefreshIndicator(
                onRefresh: () {
                  return context.read<TicketListCubit>().loadTickets();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.tickets.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemBuilder: (context, index) {
                    final ticket = state.tickets[index];

                    return Card(
                      child: ListTile(
                        onTap: () {
                          context.push('/tickets/${ticket.id}');
                        },
                        title: Text(ticket.title),
                        subtitle: Text(
                          '${_statusLabel(ticket.status)}'
                          ' • '
                          '${_priorityLabel(ticket.priority)}',
                        ),
                      ),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  String _statusLabel(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In progress';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }

  String _priorityLabel(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return 'Low';
      case TicketPriority.medium:
        return 'Medium';
      case TicketPriority.high:
        return 'High';
      case TicketPriority.urgent:
        return 'Urgent';
    }
  }
}
