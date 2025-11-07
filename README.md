# ArtConnect - Indonesian Art Freelance Marketplace

A comprehensive full-stack platform connecting talented Indonesian artists (seniman) with clients (klien) for creative projects. Built with Next.js 13, Supabase, and modern web technologies.

## Features

### Core Features (MVP)
- ✅ User authentication (email/password via Supabase Auth)
- ✅ Dual user types: Artists (Seniman) and Clients (Klien)
- ✅ Complete database schema with RLS policies
- ✅ Artist profile management with portfolio
- ✅ Project posting by clients
- ✅ Project proposal system
- ✅ Transaction and payment tracking
- ✅ Review and rating system
- ✅ Messaging system
- ✅ Notification system
- ✅ Admin audit logging

### Tech Stack

**Frontend:**
- Next.js 13 (App Router)
- TypeScript
- Tailwind CSS
- ShadCN/UI Components
- Zustand (State Management)
- Lucide React (Icons)

**Backend:**
- Supabase (PostgreSQL Database)
- Supabase Auth (Authentication)
- Row Level Security (RLS) Policies

**Planned Integrations:**
- Midtrans (Payment Gateway)
- Cloudinary (Image Storage)
- Resend (Email Service)

## Database Schema

The platform uses 11 main tables:

1. **users** - Base user authentication and profile
2. **seniman_profiles** - Extended artist profiles with ratings and portfolio metrics
3. **klien_profiles** - Extended client profiles with company information
4. **portfolio_items** - Artist portfolio showcase
5. **projects** - Job postings with status tracking
6. **project_proposals** - Artist applications to projects
7. **transactions** - Payment processing with escrow
8. **reviews** - Bidirectional reviews between clients and artists
9. **messages** - User-to-user messaging
10. **notifications** - System notifications
11. **admin_logs** - Admin activity audit trail

All tables have Row Level Security (RLS) enabled with comprehensive policies.

## Getting Started

### Prerequisites

- Node.js 18+ and npm
- A Supabase account and project

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd artconnect
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**

   Copy `.env.local.example` to `.env.local`:
   ```bash
   cp .env.local.example .env.local
   ```

   Fill in your Supabase credentials:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
   ```

4. **Database Setup**

   The database migration has already been applied to your Supabase instance. It includes:
   - All 11 tables with proper relationships
   - Custom ENUM types
   - Indexes for performance
   - Row Level Security policies
   - Default values and constraints

5. **Run the development server**
   ```bash
   npm run dev
   ```

   Open [http://localhost:3000](http://localhost:3000) to see the application.

6. **Build for production**
   ```bash
   npm run build
   npm start
   ```

## Project Structure

```
artconnect/
├── app/                          # Next.js 13 App Router
│   ├── auth/                     # Authentication pages
│   │   ├── login/
│   │   ├── register/
│   │   └── verify-email/
│   ├── layout.tsx                # Root layout with providers
│   └── page.tsx                  # Landing page
├── components/
│   ├── providers/                # React providers
│   │   └── auth-provider.tsx    # Auth state management
│   └── ui/                       # ShadCN UI components
├── lib/
│   ├── auth/
│   │   └── session.ts           # Auth helper functions
│   ├── store/
│   │   └── auth-store.ts        # Zustand auth store
│   └── supabase/
│       ├── client.ts            # Client-side Supabase
│       └── server.ts            # Server-side Supabase
└── public/                       # Static assets
```

## User Flows

### For Artists (Seniman)
1. Register as an artist
2. Complete profile with bio, location, and categories
3. Upload portfolio items
4. Browse available projects
5. Submit proposals to projects
6. Accept projects and start work
7. Receive payments upon completion
8. Get reviewed by clients

### For Clients (Klien)
1. Register as a client
2. Complete company profile
3. Post a new project with requirements
4. Review artist proposals
5. Accept proposal and initiate payment
6. Monitor project progress
7. Approve deliverables and release payment
8. Leave a review for the artist

## API Routes (To Be Implemented)

The following API endpoints are planned:

- `/api/auth/*` - Authentication endpoints
- `/api/users/*` - User profile management
- `/api/seniman/*` - Artist profiles and portfolios
- `/api/projects/*` - Project CRUD operations
- `/api/proposals/*` - Proposal management
- `/api/transactions/*` - Payment processing
- `/api/reviews/*` - Review and rating system
- `/api/messages/*` - Messaging system
- `/api/notifications/*` - Notification management
- `/api/admin/*` - Admin dashboard

## Security

- All tables have Row Level Security (RLS) enabled
- Users can only access their own data
- Public profiles are read-only for non-owners
- Admin operations require admin role verification
- Passwords are hashed via Supabase Auth
- JWT-based authentication
- HTTPS required for production

## Contributing

This is a proprietary project. Contributions are managed internally.

## License

Proprietary - All rights reserved

## Support

For support, email support@artconnect.id
