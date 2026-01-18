import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/announcement_provider.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final int announcementId;

  const AnnouncementDetailScreen({super.key, required this.announcementId});

  @override
  State<AnnouncementDetailScreen> createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnnouncementProvider>(
        context,
        listen: false,
      ).fetchAnnouncementById(widget.announcementId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    final announcement = announcementProvider.selectedAnnouncement;

    return Scaffold(
      appBar: AppBar(title: const Text('Announcement Detail')),
      body: announcementProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : announcement == null
          ? const Center(child: Text('Announcement not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            announcement.author?.fullName ?? 'Unknown',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(announcement.createdAt),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Text(
                        announcement.content,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
