import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/meeting_provider.dart';
import '../../widgets/meeting_card.dart';

class MeetingListScreen extends StatefulWidget {
  const MeetingListScreen({super.key});

  @override
  State<MeetingListScreen> createState() => _MeetingListScreenState();
}

class _MeetingListScreenState extends State<MeetingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MeetingProvider>(context, listen: false).fetchMeetings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final meetingProvider = Provider.of<MeetingProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Meetings')),
      floatingActionButton: user != null && user.canCreateMeetings
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/meetings/create');
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: meetingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : meetingProvider.meetings.isEmpty
          ? const Center(child: Text('No meetings yet'))
          : RefreshIndicator(
              onRefresh: () async {
                await meetingProvider.fetchMeetings();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: meetingProvider.meetings.length,
                itemBuilder: (context, index) {
                  final meeting = meetingProvider.meetings[index];
                  return MeetingCard(
                    meeting: meeting,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed('/meetings/detail', arguments: meeting.id);
                    },
                  );
                },
              ),
            ),
    );
  }
}
