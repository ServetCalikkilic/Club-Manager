Club Management System - Flutter Web Frontend

A comprehensive club management application built with Flutter Web.

## Features
- JWT Authentication
- Role-based access (Member, President, Admin)
- Announcements
- Meetings with attendance tracking
- Events
- Kanban task board
- Real-time chat with auto-polling

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Backend server running on http://localhost:8080

### Installation
1. Get dependencies:
   ```bash
   flutter pub get
   ```

2. Run on Chrome:
   ```bash
   flutter run -d chrome
   ```

## Architecture
- State Management: Provider
- HTTP Client: Dio with JWT interceptor
- Secure Storage: flutter_secure_storage
- Date Formatting: intl
