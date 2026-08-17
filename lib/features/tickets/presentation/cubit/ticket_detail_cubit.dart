import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/errors/ticket_exception.dart';
import '../../domain/repositories/ticket_repository.dart';
import 'ticket_detail_state.dart';
import '../../domain/entities/ticket.dart';

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

  Future<void> updateStatus(TicketStatus status) async {
    final currentTicket = state.ticket;

    if (state.status != TicketDetailStatus.success ||
        currentTicket == null ||
        currentTicket.status == status ||
        state.statusUpdateStatus == TicketStatusUpdateStatus.submitting) {
      return;
    }

    emit(
      TicketDetailState(
        status: TicketDetailStatus.success,
        ticket: currentTicket,
        statusUpdateStatus: TicketStatusUpdateStatus.submitting,
      ),
    );

    try {
      final updatedTicket = await _ticketRepository.updateTicketStatus(
        ticketId: currentTicket.id,
        status: status,
      );

      emit(
        TicketDetailState(
          status: TicketDetailStatus.success,
          ticket: updatedTicket,
        ),
      );
    } on TicketException catch (error) {
      emit(
        TicketDetailState(
          status: TicketDetailStatus.success,
          ticket: currentTicket,
          statusUpdateStatus: TicketStatusUpdateStatus.failure,
          statusUpdateErrorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        TicketDetailState(
          status: TicketDetailStatus.success,
          ticket: currentTicket,
          statusUpdateStatus: TicketStatusUpdateStatus.failure,
          statusUpdateErrorMessage: 'Failed to update ticket status',
        ),
      );
    }
  }
}
