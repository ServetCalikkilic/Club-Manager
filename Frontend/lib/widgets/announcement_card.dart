import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/announcement.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback onTap;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(child: Icon(Icons.announcement)),
        title: Text(
          announcement.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              announcement.content.length > 100
                  ? '${announcement.content.substring(0, 100)}...'
                  : announcement.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'By ${announcement.author?.fullName ?? 'Unknown'} • ${DateFormat('MMM dd, yyyy').format(announcement.createdAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
