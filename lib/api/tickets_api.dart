import 'package:dio/dio.dart';

class TicketApi {
  final String _baseUrl = 'https://api.qline.app/api';
  final Dio _dio = Dio();

  Future<dynamic> createTicket(
      String token, String title, String topic, String message) async {
    final data = {
      'title': title,
      'topic': topic,
      'message': message,
    };

    try {
      final response = await _dio.post(
        '$_baseUrl/tickets',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data["success"] == true) {
          var res = response.data;
          return res;
        } else {
          // error = response.data["msg"];
          return null;
        }
      } else if (response.statusCode == 404) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Ticket request failed');
    }
  }

  Future<dynamic> ticketList(
    String token,
  ) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/tickets',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        List<dynamic> tickets = response.data;
        tickets.sort((a, b) {
          DateTime dateA = DateTime.parse(a['updated_at']);
          DateTime dateB = DateTime.parse(b['updated_at']);
          return dateB.compareTo(dateA);
        });
        return tickets;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Ticket request failed');
    }
  }

  Future<dynamic> getTicketDetails(String token, int ticketId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/tickets/messages?id=$ticketId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data["success"] == true) {
          dynamic ticketDetails = response.data["ticket"];
          return ticketDetails;
        } else {
          // error = response.data["msg"];
          return null;
        }
      } else if (response.statusCode == 404) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch ticket details');
    }
  }

  Future<dynamic> respondTicket(
      String token, String message, int ticketId) async {
    final data = {
      'message': message,
      'method': 'PUT',
      'id': ticketId,
    };

    try {
      final response = await _dio.post(
        '$_baseUrl/tickets/respond',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data["success"] == true) {
          var res = response.data;
          return res;
        } else {
          return null;
        }
      } else if (response.statusCode == 404) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to respond to ticket');
    }
  }

  Future<dynamic> closeTicket(String token, int ticketId) async {
    final data = {
      'id': ticketId,
    };

    try {
      final response = await _dio.post(
        '$_baseUrl/tickets/close',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data["success"] == true) {
          var res = response.data;
          return res;
        } else {
          return null;
        }
      } else if (response.statusCode == 404) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to close ticket');
    }
  }
}
