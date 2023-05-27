import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_news/localizations/localizations.dart';
import 'dart:convert';

import '../../api/tickets_api.dart';
import '../../bloc/settings/settings_cubit.dart';

class TicketDetailsScreen extends StatefulWidget {
  final int ticketId;

  const TicketDetailsScreen({Key? key, required this.ticketId})
      : super(key: key);

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  late final SettingsCubit settings;

  final TicketApi _ticketApi = TicketApi();
  final TextEditingController _messageController = TextEditingController();
  dynamic _ticketDetails = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    try {
      settings = context.read<SettingsCubit>();
    } catch (e) {
      //pass
    }
    _loadTicketDetails();
  }

  Future<void> _loadTicketDetails() async {
    try {
      dynamic ticketDetails = await _ticketApi.getTicketDetails(
          settings.state.userInfo[0], widget.ticketId);
      setState(() {
        _ticketDetails = ticketDetails;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error
    }
  }

  Future<void> _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }

    try {
      dynamic response = await _ticketApi.respondTicket(
        settings.state.userInfo[0],
        message,
        widget.ticketId,
      );

      if (response != null && response['success'] == true) {
        setState(() {
          _ticketDetails['messages'].add({
            'time': DateTime.now().toString(),
            'user': true,
            'message': message,
          });
          _messageController.clear();
        });
      } else {
        // Handle the error
      }
    } catch (e) {
      // Handle the error
    }
    _loadTicketDetails();
  }

  Future<void> _closeTicket() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTranslatedText(context, "close_ticket")),
          content: Text(getTranslatedText(context, "close_ticket_message")),
          actions: [
            TextButton(
              child: Text(getTranslatedText(context, "cancel")),
              onPressed: () {
                GoRouter.of(context).push("/ticket_list");
              },
            ),
            TextButton(
              child: Text(getTranslatedText(context, "close")),
              onPressed: () {
                Navigator.of(context).pop();
                _performTicketClosure();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performTicketClosure() async {
    try {
      dynamic response = await _ticketApi.closeTicket(
        settings.state.userInfo[0],
        widget.ticketId,
      );

      if (response != null && response['success'] == true) {
        setState(() {
          _ticketDetails['status'] = 'closed';
        });
        _showTicketClosedDialog();
      } else {
        // Handle the error
      }
    } catch (e) {
      // Handle the error
    }
    _loadTicketDetails();
  }

  void _showTicketClosedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTranslatedText(context, "ticket_closed_2")),
          content: Text(getTranslatedText(context, "ticket_closed_message_2")),
          actions: [
            TextButton(
              child: Text(getTranslatedText(context, "ok")),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslatedText(context, "ticket_detail")),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildTicketDetails(),
    );
  }

  Widget _buildTicketDetails() {
    List<dynamic> messages = jsonDecode(_ticketDetails['messages']);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "${getTranslatedText(context, "title")}: ",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _ticketDetails['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Status: ${_ticketDetails['status']}'),
          const SizedBox(height: 16),
          Text(
            getTranslatedText(context, "messages"),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                dynamic message = messages[index];
                bool isUserMessage = message['user'] ?? false;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: isUserMessage
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isUserMessage ? Colors.green[800] : null,
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['message'].toString(),
                                  style: TextStyle(
                                    color: isUserMessage ? Colors.white : null,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    _formatDateTime(message['time'].toString()),
                                    style: TextStyle(
                                      color:
                                          isUserMessage ? Colors.white : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: isUserMessage ? 12 : 8,
                        bottom: isUserMessage ? 8 : 0,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: isUserMessage
                          ? CircleAvatar(
                              child: Text(
                                  settings.state.userInfo[1].substring(0, 2)),
                            )
                          : const CircleAvatar(
                              child: Text("SP"),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: getTranslatedText(context, "type_message"),
                    fillColor: Colors.grey.withOpacity(0.2),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _closeTicket,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr.replaceAll("  ", " "));
    return DateFormat.yMd().add_jm().format(dateTime);
  }
}
