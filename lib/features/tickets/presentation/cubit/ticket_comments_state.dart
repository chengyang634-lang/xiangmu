import '../../domain/entities/ticket_comment.dart';

enum TicketCommentsStatus { initial, loading, success, failure }

class TicketCommentsState {
  const TicketCommentsState({
    this.status = TicketCommentsStatus.initial,
    this.comments = const [],
    this.errorMessage,
  });

  final TicketCommentsStatus status;
  final List<TicketComment> comments;
  final String? errorMessage;
}
