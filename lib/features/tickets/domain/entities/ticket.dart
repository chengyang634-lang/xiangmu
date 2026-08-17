enum TicketStatus { open, inProgress, resolved, closed }

enum TicketPriority { low, medium, high, urgent }

class Ticket {
  const Ticket({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  final String id;
  final String title;
  final TicketStatus status;
  final TicketPriority priority;
  final DateTime createdAt;
}
