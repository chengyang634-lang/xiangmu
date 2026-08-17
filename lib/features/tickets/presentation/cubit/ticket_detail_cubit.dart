import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/errors/ticket_exception.dart';
import '../../domain/repositories/ticket_repository.dart';
import 'ticket_detail_state.dart';

class TicketDetailCubit extends Cubit<TicketDetailState> {
  TicketDetailCubit(this._ticketRepository) : super(const TicketDetailState());

  final TicketRepository _ticketRepository;

  Future<void> loadTicket(String ticketId) async {
    emit(const TicketDetailState(status: TicketDetailStatus.loading));

    try {
      final ticket = await _ticketRepository.getTicket(ticketId);

      emit(
        TicketDetailState(status: TicketDetailStatus.success, ticket: ticket),
      );
    } on TicketException catch (error) {
      emit(
        TicketDetailState(
          status: TicketDetailStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        const TicketDetailState(
          status: TicketDetailStatus.failure,
          errorMessage: 'Failed to load ticket',
        ),
      );
    }
  }
}
