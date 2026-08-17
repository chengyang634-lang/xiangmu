import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/errors/ticket_exception.dart';
import '../../domain/repositories/ticket_repository.dart';
import 'ticket_comments_state.dart';

class TicketCommentsCubit extends Cubit<TicketCommentsState> {
  TicketCommentsCubit(this._ticketRepository)
    : super(const TicketCommentsState());

  final TicketRepository _ticketRepository;

  Future<void> loadComments(String ticketId) async {
    emit(const TicketCommentsState(status: TicketCommentsStatus.loading));

    try {
      final comments = await _ticketRepository.getComments(ticketId);

      emit(
        TicketCommentsState(
          status: TicketCommentsStatus.success,
          comments: comments,
        ),
      );
    } on TicketException catch (error) {
      emit(
        TicketCommentsState(
          status: TicketCommentsStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        const TicketCommentsState(
          status: TicketCommentsStatus.failure,
          errorMessage: 'Failed to load ticket comments',
        ),
      );
    }
  }
}
