# Club-Manager

Club-Manager is a simple, extensible application to help sports clubs, student organizations, and social groups manage memberships, events, and administration. This repository provides a starting point for creating clubs, registering members, planning events, and generating basic reports.

## Features
- Create and manage clubs
- Member management (create, update, delete)
- Event/meeting scheduling and participant tracking
- Role-based access control (admin, member)
- Basic reports (member lists, event participation)
- API-first design for easy integration

## Technology Stack (examples)
- Backend: Node.js + Express (or your preferred backend)
- Database: PostgreSQL / MySQL / SQLite
- ORM: Prisma / TypeORM / Sequelize
- Frontend: React / Vue / Angular (optional)
- Docker (optional)

> Note: Swap technologies above to match your team's preferences. Commands below are example workflows.
## <img width="700" height="904" alt="image" src="https://github.com/user-attachments/assets/13c33e9c-19bc-4255-a7d0-62b4c959073f" />
## <img width="700" height="909" alt="image" src="https://github.com/user-attachments/assets/0eb62624-a62a-4f32-aa96-689a88b29e85" />

## API Endpoints
These are endpoints

- POST /api/auth/register — Register new user
- POST /api/auth/login — Login (returns JWT)
- GET /api/clubs — List clubs
- POST /api/clubs — Create a club (admin)
- GET /api/clubs/:id/members — List club members
- POST /api/clubs/:id/members — Add a member
- POST /api/clubs/:id/events — Create an event
- GET /api/events/:id/participants — List event participants

## Contact
Repository owner: ServetCalikkilic  
For questions or contributions, open an issue in this repository.
