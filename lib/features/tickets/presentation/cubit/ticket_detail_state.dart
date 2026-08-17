import '../../domain/entities/ticket_details.dart';

enum TicketDetailStatus { initial, loading, success, failure }

class TicketDetailState {
  const TicketDetailState({
    this.status = TicketDetailStatus.initial,
    this.ticket,
    this.errorMessage,
  });

  final TicketDetailStatus status;
  final TicketDetails? ticket;
  final String? errorMessage;
}
