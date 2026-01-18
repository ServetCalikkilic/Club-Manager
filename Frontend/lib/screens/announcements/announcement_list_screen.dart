import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/announcement_provider.dart';
import '../../widgets/announcement_card.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({super.key});

  @override
  State<AnnouncementListScreen> createState() => _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnnouncementProvider>(
        context,
        listen: false,
      ).fetchAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      floatingActionButton: user != null && user.canCreateAnnouncements
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/announcements/create');
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: announcementProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : announcementProvider.announcements.isEmpty
              ? const Center(child: Text('No announcements yet'))
              : RefreshIndicator(
                  onRefresh: () async {
                    await announcementProvider.fetchAnnouncements();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: announcementProvider.announcements.length,
                    itemBuilder: (context, index) {
                      final announcement =
                          announcementProvider.announcements[index];
                      return AnnouncementCard(
                        announcement: announcement,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/announcements/detail',
                            arguments: announcement.id,
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
