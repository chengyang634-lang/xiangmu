import '../../domain/entities/ticket.dart';

enum TicketListStatus { initial, loading, success, failure }

class TicketListState {
  const TicketListState({
    this.status = TicketListStatus.initial,
    this.tickets = const [],
    this.errorMessage,
  });

  final TicketListStatus status;
  final List<Ticket> tickets;
  final String? errorMessage;
}
