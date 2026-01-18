import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/meeting_provider.dart';
import 'providers/event_provider.dart';
import 'providers/task_provider.dart';
import 'providers/chat_provider.dart';

import 'services/dio_client.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/announcements/announcement_list_screen.dart';
import 'screens/announcements/announcement_detail_screen.dart';
import 'screens/announcements/create_announcement_screen.dart';
import 'screens/meetings/meeting_list_screen.dart';
import 'screens/meetings/meeting_detail_screen.dart';
import 'screens/meetings/create_meeting_screen.dart';
import 'screens/events/event_list_screen.dart';
import 'screens/tasks/task_board_screen.dart';
import 'screens/chat/chat_screen.dart';

void main() {
  // Initialize Dio client
  DioClient().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..loadUserFromStorage(),
        ),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => MeetingProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Club Management System',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
            initialRoute: authProvider.isAuthenticated
                ? '/dashboard'
                : '/login',
            onGenerateRoute: (settings) {
              // Route guards
              final isAuthenticated = authProvider.isAuthenticated;

              switch (settings.name) {
                case '/login':
                  return MaterialPageRoute(builder: (_) => const LoginScreen());
                case '/register':
                  return MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  );
                case '/dashboard':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (_) => const DashboardScreen(),
                  );
                case '/profile':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  );
                case '/announcements':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (_) => const AnnouncementListScreen(),
                  );
                case '/announcements/detail':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  final announcementId = settings.arguments as int;
                  return MaterialPageRoute(
                    builder: (_) => AnnouncementDetailScreen(
                      announcementId: announcementId,
                    ),
                  );
                case '/announcements/create':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (_) => const CreateAnnouncementScreen(),
                  );
                case '/meetings':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (_) => const MeetingListScreen(),
                  );
                case '/meetings/detail':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  final meetingId = settings.arguments as int;
                  return MaterialPageRoute(
                    builder: (_) => MeetingDetailScreen(meetingId: meetingId),
                  );
                case '/meetings/create':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (_) => const CreateMeetingScreen(),
                  );
                case '/events':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (_) => const EventListScreen(),
                  );
                case '/tasks':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (_) => const TaskBoardScreen(),
                  );
                case '/chat':
                  if (!isAuthenticated) {
                    return MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    );
                  }
                  return MaterialPageRoute(builder: (_) => const ChatScreen());
                default:
                  return MaterialPageRoute(builder: (_) => const LoginScreen());
              }
            },
          );
        },
      ),
    );
  }
}
