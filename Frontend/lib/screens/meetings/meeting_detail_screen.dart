import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/meeting_provider.dart';
import '../../models/attendance.dart';

class MeetingDetailScreen extends StatefulWidget {
  final int meetingId;

  const MeetingDetailScreen({super.key, required this.meetingId});

  @override
  State<MeetingDetailScreen> createState() => _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MeetingProvider>(context, listen: false);
      provider.fetchMeetingById(widget.meetingId);
      provider.fetchAttendances(widget.meetingId);
    });
  }

  Future<void> _updateAttendance(AttendanceStatus status) async {
    final provider = Provider.of<MeetingProvider>(context, listen: false);
    final success = await provider.updateAttendance(
      meetingId: widget.meetingId,
      status: status,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance updated'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final meetingProvider = Provider.of<MeetingProvider>(context);
    final meeting = meetingProvider.selectedMeeting;
    final attendances = meetingProvider.attendances;

    return Scaffold(
      appBar: AppBar(title: const Text('Meeting Detail')),
      body: meetingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : meeting == null
          ? const Center(child: Text('Meeting not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meeting.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat(
                                  'MMM dd, yyyy - HH:mm',
                                ).format(meeting.meetingDate),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Text(
                            meeting.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Attendance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _updateAttendance(AttendanceStatus.COMING),
                          icon: const Icon(Icons.check),
                          label: const Text('Coming'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _updateAttendance(AttendanceStatus.NOT_COMING),
                          icon: const Icon(Icons.close),
                          label: const Text('Not Coming'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Attendees',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: attendances.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No attendance data yet'),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: attendances.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final att = attendances[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    att.user?.fullName
                                            .substring(0, 1)
                                            .toUpperCase() ??
                                        '?',
                                  ),
                                ),
                                title: Text(att.user?.fullName ?? 'Unknown'),
                                trailing: Chip(
                                  label: Text(att.status.name),
                                  backgroundColor:
                                      att.status == AttendanceStatus.COMING
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
