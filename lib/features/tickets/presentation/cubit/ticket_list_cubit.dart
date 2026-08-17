import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/errors/ticket_exception.dart';
import '../../domain/repositories/ticket_repository.dart';
import 'ticket_list_state.dart';

class TicketListCubit extends Cubit<TicketListState> {
  TicketListCubit(this._ticketRepository) : super(const TicketListState());

  final TicketRepository _ticketRepository;

  Future<void> loadTickets() async {
    emit(const TicketListState(status: TicketListStatus.loading));

    try {
      final tickets = await _ticketRepository.getTickets();

      emit(TicketListState(status: TicketListStatus.success, tickets: tickets));
    } on TicketException catch (error) {
      emit(
        TicketListState(
          status: TicketListStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        const TicketListState(
          status: TicketListStatus.failure,
          errorMessage: 'Failed to load tickets',
        ),
      );
    }
  }
}
