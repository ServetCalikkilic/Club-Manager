# Club Management System Backend

## Prerequisites
- Java 17 or higher
- PostgreSQL 12 or higher
- Maven 3.6+

## Setup Instructions

### 1. Database Setup
Create a PostgreSQL database:
```sql
CREATE DATABASE club_management;
```

### 2. Configure Database Connection
Edit `src/main/resources/application.properties` and update:
```properties
spring.datasource.username=your_postgres_username
spring.datasource.password=your_postgres_password
```

### 3. Build and Run
```bash
# Build the project
mvn clean install

# Run the application
mvn spring-boot:run
```

The application will start on `http://localhost:8080`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login
- `GET /api/auth/profile` - Get current user profile (requires JWT)

### Announcements
- `GET /api/announcements` - Get all announcements
- `GET /api/announcements/{id}` - Get announcement by ID
- `POST /api/announcements` - Create announcement (PRESIDENT/ADMIN only)
- `PUT /api/announcements/{id}` - Update announcement (PRESIDENT/ADMIN only)
- `DELETE /api/announcements/{id}` - Delete announcement (PRESIDENT/ADMIN only)

### Meetings
- `GET /api/meetings` - Get all meetings
- `GET /api/meetings/{id}` - Get meeting by ID
- `POST /api/meetings` - Create meeting (PRESIDENT only)
- `POST /api/meetings/{id}/attend` - Update attendance status
- `GET /api/meetings/{id}/attendances` - Get all attendances for a meeting

### Events
- `GET /api/events` - Get all events
- `GET /api/events/{id}` - Get event by ID
- `POST /api/events` - Create event

### Tasks
- `GET /api/tasks` - Get all tasks (optional ?status=TODO/DOING/DONE)
- `POST /api/tasks` - Create task
- `PUT /api/tasks/{id}/status` - Update task status

### Chat
- `GET /api/chat/messages?limit=50` - Get messages (default 50)
- `POST /api/chat/messages` - Send message
- `GET /api/chat/messages/latest?after=2024-01-13T10:00:00` - Get messages after timestamp (for polling)

## User Roles
- `MEMBER` - Regular club member
- `PRESIDENT` - Club president (can create announcements and meetings)
- `ADMIN` - Administrator (full access)

## Authentication
All endpoints except `/api/auth/**` require JWT authentication.

Include the JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## Default Channel
The system automatically creates a `#general` chat channel on startup.

## Testing
Use tools like Postman or curl to test the API endpoints.

Example registration:
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "president1",
    "email": "president@club.com",
    "password": "password123",
    "fullName": "Club President",
    "role": "PRESIDENT"
  }'
```
