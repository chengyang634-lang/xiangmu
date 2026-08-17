import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ticket.dart';
import '../cubit/ticket_detail_cubit.dart';
import '../cubit/ticket_detail_state.dart';

class TicketDetailPage extends StatelessWidget {
  const TicketDetailPage({required this.ticketId, super.key});

  final String ticketId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket details')),
      body: BlocConsumer<TicketDetailCubit, TicketDetailState>(
        listenWhen: (previous, current) {
          return previous.statusUpdateStatus != current.statusUpdateStatus;
        },
        listener: (context, state) {
          if (state.statusUpdateStatus == TicketStatusUpdateStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.statusUpdateErrorMessage ??
                      'Failed to update ticket status',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case TicketDetailStatus.initial:
            case TicketDetailStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case TicketDetailStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage ?? 'Failed to load ticket'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TicketDetailCubit>().loadTicket(ticketId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );

            case TicketDetailStatus.success:
              final ticket = state.ticket;

              if (ticket == null) {
                return const Center(child: Text('Ticket unavailable'));
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    ticket.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  Text(ticket.description),

                  const SizedBox(height: 24),

                  Text('Status', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),

                  DropdownButton<TicketStatus>(
                    value: ticket.status,
                    isExpanded: true,
                    onChanged:
                        state.statusUpdateStatus ==
                            TicketStatusUpdateStatus.submitting
                        ? null
                        : (status) {
                            if (status == null) {
                              return;
                            }

                            context.read<TicketDetailCubit>().updateStatus(
                              status,
                            );
                          },
                    items: TicketStatus.values
                        .map((status) {
                          return DropdownMenuItem<TicketStatus>(
                            value: status,
                            child: Text(_statusLabel(status)),
                          );
                        })
                        .toList(growable: false),
                  ),

                  if (state.statusUpdateStatus ==
                      TicketStatusUpdateStatus.submitting) ...[
                    const SizedBox(height: 8),
                    const LinearProgressIndicator(),
                  ],

                  const SizedBox(height: 16),

                  Text('Priority: ${_priorityLabel(ticket.priority)}'),
                  const SizedBox(height: 8),

                  Text('Created: ${ticket.createdAt.toLocal()}'),
                ],
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
