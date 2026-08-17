import 'package:dio/dio.dart';

import '../../domain/entities/ticket.dart';
import '../../domain/errors/ticket_exception.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../../domain/entities/ticket_details.dart';

class DioTicketRepository implements TicketRepository {
  DioTicketRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Ticket>> getTickets() async {
    try {
      final response = await _dio.get<dynamic>('/api/tickets');

      final data = response.data;

      if (data is! List) {
        throw const TicketException('Invalid ticket list response');
      }

      return data
          .map<Ticket>((item) {
            if (item is! Map) {
              throw const TicketException('Invalid ticket response');
            }

            final id = item['id'];
            final title = item['title'];
            final status = item['status'];
            final priority = item['priority'];
            final createdAt = item['createdAt'];

            if (id is! String ||
                id.isEmpty ||
                title is! String ||
                title.isEmpty ||
                status is! String ||
                priority is! String ||
                createdAt is! String) {
              throw const TicketException('Invalid ticket response');
            }

            final parsedCreatedAt = DateTime.tryParse(createdAt);

            if (parsedCreatedAt == null) {
              throw const TicketException('Invalid ticket response');
            }

            return Ticket(
              id: id,
              title: title,
              status: _parseStatus(status),
              priority: _parsePriority(priority),
              createdAt: parsedCreatedAt,
            );
          })
          .toList(growable: false);
    } on TicketException {
      rethrow;
    } on DioException catch (error) {
      final data = error.response?.data;

      if (data is Map) {
        final message = data['message'];

        if (message is String && message.isNotEmpty) {
          throw TicketException(message);
        }
      }

      throw const TicketException('Failed to load tickets');
    }
  }

  @override
  Future<TicketDetails> getTicket(String ticketId) async {
    try {
      final response = await _dio.get<dynamic>('/api/tickets/$ticketId');

      final data = response.data;

      if (data is! Map) {
        throw const TicketException('Invalid ticket detail response');
      }

      final id = data['id'];
      final title = data['title'];
      final description = data['description'];
      final status = data['status'];
      final priority = data['priority'];
      final createdAt = data['createdAt'];

      if (id is! String ||
          id.isEmpty ||
          title is! String ||
          title.isEmpty ||
          description is! String ||
          status is! String ||
          priority is! String ||
          createdAt is! String) {
        throw const TicketException('Invalid ticket detail response');
      }

      final parsedCreatedAt = DateTime.tryParse(createdAt);

      if (parsedCreatedAt == null) {
        throw const TicketException('Invalid ticket detail response');
      }

      return TicketDetails(
        id: id,
        title: title,
        description: description,
        status: _parseStatus(status),
        priority: _parsePriority(priority),
        createdAt: parsedCreatedAt,
      );
    } on TicketException {
      rethrow;
    } on DioException catch (error) {
      final data = error.response?.data;

      if (data is Map) {
        final message = data['message'];

        if (message is String && message.isNotEmpty) {
          throw TicketException(message);
        }
      }

      throw const TicketException('Failed to load ticket');
    }
  }

  TicketStatus _parseStatus(String value) {
    switch (value) {
      case 'open':
        return TicketStatus.open;
      case 'in_progress':
        return TicketStatus.inProgress;
      case 'resolved':
        return TicketStatus.resolved;
      case 'closed':
        return TicketStatus.closed;
      default:
        throw const TicketException('Invalid ticket status');
    }
  }

  TicketPriority _parsePriority(String value) {
    switch (value) {
      case 'low':
        return TicketPriority.low;
      case 'medium':
        return TicketPriority.medium;
      case 'high':
        return TicketPriority.high;
      case 'urgent':
        return TicketPriority.urgent;
      default:
        throw const TicketException('Invalid ticket priority');
    }
  }
}
