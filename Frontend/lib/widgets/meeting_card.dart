import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/meeting.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final VoidCallback onTap;

  const MeetingCard({super.key, required this.meeting, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(child: Icon(Icons.meeting_room)),
        title: Text(
          meeting.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              meeting.description.length > 50
                  ? '${meeting.description.substring(0, 50)}...'
                  : meeting.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  DateFormat(
                    'MMM dd, yyyy - HH:mm',
                  ).format(meeting.meetingDate),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
