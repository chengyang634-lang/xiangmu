import 'ticket.dart';

class TicketDetails {
  const TicketDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final DateTime createdAt;
}
