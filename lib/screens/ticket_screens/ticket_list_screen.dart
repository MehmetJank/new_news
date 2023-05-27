import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_news/localizations/localizations.dart';

import '../../api/tickets_api.dart';
import '../../bloc/settings/settings_cubit.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  late final SettingsCubit settings;
  final TicketApi _ticketApi = TicketApi();
  List<dynamic> _tickets = [];
  bool _isLoading = true;
  bool _isCircleVisible = true;
  bool _isFlashing = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    try {
      settings = context.read<SettingsCubit>();
    } catch (e) {
      //pass
    }
    _loadTickets();
    startFlashingAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadTickets() async {
    try {
      List<dynamic> tickets = await _ticketApi.ticketList(
        settings.state.userInfo[0],
      );
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error
    }
  }

  void _navigateToTicketDetails(int ticketId) {
    GoRouter.of(context).push(
      '/ticket/$ticketId',
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTranslatedText(context, "ticket_closed")),
          content: Text(getTranslatedText(context, "ticket_closed_message")),
          actions: [
            TextButton(
              child: Text(getTranslatedText(context, "ok")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startFlashingAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          _isFlashing = !_isFlashing;
          _isCircleVisible = !_isCircleVisible; // Toggle the visibility
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslatedText(context, "ticket_list")),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTickets,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: _buildTicketList(),
              ),
      ),
    );
  }

  Widget _buildTicketList() {
    return ListView.builder(
      itemCount: _tickets.length,
      itemBuilder: (context, index) {
        dynamic ticket = _tickets[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              ticket['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Row(
              children: [
                Text(
                  getTranslatedText(context, "status"),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                if (ticket['status'] == 'user_closed')
                  const Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 14,
                  ),
                if (ticket['status'] != 'user_closed')
                  AnimatedOpacity(
                    opacity: _isCircleVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Text(
              _formatDateTime(ticket['updated_at']),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/icons/support.svg',
                // ignore: deprecated_member_use
                color: Colors.white,
              ),
            ),
            onTap: () {
              if (ticket['status'] != 'user_closed') {
                _navigateToTicketDetails(ticket['id']);
              } else {
                _showAlertDialog();
              }
            },
          ),
        );
      },
    );
  }

  String _formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return DateFormat.yMd().add_jm().format(dateTime);
  }
}
