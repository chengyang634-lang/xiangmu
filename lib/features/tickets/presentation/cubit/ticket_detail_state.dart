import '../../domain/entities/ticket_details.dart';

enum TicketDetailStatus { initial, loading, success, failure }

enum TicketStatusUpdateStatus { idle, submitting, failure }

class TicketDetailState {
  const TicketDetailState({
    this.status = TicketDetailStatus.initial,
    this.ticket,
    this.errorMessage,
    this.statusUpdateStatus = TicketStatusUpdateStatus.idle,
    this.statusUpdateErrorMessage,
  });

  final TicketDetailStatus status;
  final TicketDetails? ticket;
  final String? errorMessage;

  final TicketStatusUpdateStatus statusUpdateStatus;
  final String? statusUpdateErrorMessage;
}
