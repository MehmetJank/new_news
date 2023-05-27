import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_news/localizations/localizations.dart';

import '../../api/tickets_api.dart';
import '../../bloc/settings/settings_cubit.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({Key? key}) : super(key: key);

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  late final SettingsCubit settings;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final TicketApi _ticketApi = TicketApi();

  String selectedTopic = '';
  String customTopic = '';

  bool _isCreatingTicket = false;

  @override
  void initState() {
    super.initState();
    try {
      settings = context.read<SettingsCubit>();
    } catch (e) {
      //pass
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _createTicket() async {
    final String title = _titleController.text;
    final String topic = selectedTopic;
    final String message = _messageController.text;

    if (title.isEmpty || topic.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getTranslatedText(context, "please_fill_all_fields")),
        ),
      );
      return;
    }

    setState(() {
      _isCreatingTicket = true;
    });

    try {
      final response = await _ticketApi.createTicket(
          settings.state.userInfo[0], title, topic, message);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(getTranslatedText(context, "ticket_create_success")),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(getTranslatedText(context, "ticket_create_error")),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getTranslatedText(context, "ticket_create_error")),
        ),
      );
    } finally {
      setState(() {
        _isCreatingTicket = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    selectedTopic = getTranslatedText(context, "accounting");

    List<String> topics = [
      getTranslatedText(context, "accounting"),
      getTranslatedText(context, "student_affairs"),
      getTranslatedText(context, "rectorate"),
      getTranslatedText(context, "computing"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslatedText(context, "create_ticket")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: customTopic.isNotEmpty ? customTopic : selectedTopic,
              decoration: InputDecoration(
                labelText: getTranslatedText(context, 'topic'),
                fillColor: Colors.grey.withOpacity(0.2),
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              items: [
                ...topics.map((String topic) {
                  return DropdownMenuItem<String>(
                    value: topic,
                    child: Text(topic),
                  );
                }).toList(),
                if (customTopic.isNotEmpty)
                  DropdownMenuItem<String>(
                    value: customTopic,
                    child: Text(customTopic),
                  ),
                DropdownMenuItem<String>(
                  value: 'Custom Topic',
                  child: Text(getTranslatedText(context, 'custom_topic')),
                ),
              ],
              onChanged: (String? value) {
                if (value == 'Custom Topic') {
                  customTopic = '';
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                            getTranslatedText(context, "enter_custom_topic")),
                        content: TextField(
                          onChanged: (value) {
                            setState(() {
                              customTopic = value;
                            });
                          },
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(getTranslatedText(context, "ok")),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(
                    () {
                      selectedTopic = value!;
                      customTopic = '';
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.2),
                labelText: getTranslatedText(context, "title"),
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.2),
                labelText: getTranslatedText(context, "message"),
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: _isCreatingTicket ? null : _createTicket,
                child: _isCreatingTicket
                    ? const CircularProgressIndicator()
                    : Text(getTranslatedText(context, "create_ticket")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
