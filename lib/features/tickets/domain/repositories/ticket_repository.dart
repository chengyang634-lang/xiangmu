import '../entities/ticket.dart';
import '../entities/ticket_comment.dart';
import '../entities/ticket_details.dart';

abstract class TicketRepository {
  Future<List<Ticket>> getTickets();

  Future<TicketDetails> getTicket(String ticketId);

  Future<TicketDetails> updateTicketStatus({
    required String ticketId,
    required TicketStatus status,
  });

  Future<List<TicketComment>> getComments(String ticketId);
}
