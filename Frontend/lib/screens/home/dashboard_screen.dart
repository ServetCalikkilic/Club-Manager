import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const CustomDrawer(),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                            'Welcome, ${user.fullName}!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Role: ${user.role.name}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Quick Links',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildQuickLinkCard(
                          context,
                          icon: Icons.announcement,
                          title: 'Announcements',
                          route: '/announcements',
                          color: Colors.blue,
                        ),
                        _buildQuickLinkCard(
                          context,
                          icon: Icons.meeting_room,
                          title: 'Meetings',
                          route: '/meetings',
                          color: Colors.green,
                        ),
                        _buildQuickLinkCard(
                          context,
                          icon: Icons.event,
                          title: 'Events',
                          route: '/events',
                          color: Colors.orange,
                        ),
                        _buildQuickLinkCard(
                          context,
                          icon: Icons.task,
                          title: 'Tasks',
                          route: '/tasks',
                          color: Colors.purple,
                        ),
                        _buildQuickLinkCard(
                          context,
                          icon: Icons.chat,
                          title: 'Chat',
                          route: '/chat',
                          color: Colors.teal,
                        ),
                        _buildQuickLinkCard(
                          context,
                          icon: Icons.person,
                          title: 'Profile',
                          route: '/profile',
                          color: Colors.indigo,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildQuickLinkCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
