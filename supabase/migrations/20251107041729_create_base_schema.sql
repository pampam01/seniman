/*
  # Create Base Schema for Art Freelance Marketplace

  ## Overview
  This migration creates the foundational database structure for a marketplace connecting artists (seniman) with clients (klien).

  ## 1. New Tables

  ### users
  - Core user table with authentication and profile data
  - `id` (uuid, primary key)
  - `email` (text, unique)
  - `password_hash` (text)
  - `user_type` (enum: seniman, klien, admin)
  - `first_name`, `last_name` (text)
  - `profile_picture_url` (text)
  - `phone` (text)
  - `is_verified` (boolean)
  - `email_verified_at` (timestamp)
  - Soft delete support with `deleted_at`

  ### seniman_profiles
  - Extended profile for artists
  - Links to users table
  - Includes bio, location, categories, rates, ratings
  - Verification and availability status
  - Portfolio metrics

  ### klien_profiles
  - Extended profile for clients
  - Company information
  - Project and spending metrics
  - Buyer ratings

  ### portfolio_items
  - Artist portfolio showcase
  - Multiple images support
  - Categorization and featured items

  ### projects
  - Job postings by clients
  - Links to both klien and seniman
  - Status tracking from draft to completion
  - Budget and timeline management

  ### project_proposals
  - Seniman applications to projects
  - Negotiation support
  - Status tracking

  ### transactions
  - Payment processing
  - Escrow management
  - Platform fee calculation
  - Gateway integration tracking

  ### reviews
  - Bidirectional reviews (klien ↔ seniman)
  - Multiple rating dimensions
  - Linked to completed projects

  ### messages
  - User-to-user messaging
  - Project context support
  - Read status tracking

  ### notifications
  - User notifications
  - Multiple notification types
  - Read status tracking

  ### admin_logs
  - Audit trail for admin actions
  - JSON storage of old/new values

  ## 2. Security
  - RLS enabled on all tables
  - Policies for authenticated users to manage their own data
  - Admin-only access for admin_logs
  - Public read access for seniman profiles and portfolios

  ## 3. Indexes
  - Performance indexes on foreign keys
  - Search indexes on frequently queried columns
  - Composite indexes for common query patterns
*/

-- Create ENUMs
CREATE TYPE user_type AS ENUM ('seniman', 'klien', 'admin');
CREATE TYPE availability_status AS ENUM ('available', 'busy', 'on_break');
CREATE TYPE verification_status AS ENUM ('unverified', 'pending', 'verified');
CREATE TYPE company_size AS ENUM ('personal', 'startup', 'small', 'medium', 'large');
CREATE TYPE project_status AS ENUM ('draft', 'posted', 'negotiating', 'accepted', 'in_progress', 'completed', 'cancelled');
CREATE TYPE budget_type AS ENUM ('fixed', 'hourly');
CREATE TYPE proposal_status AS ENUM ('pending', 'accepted', 'rejected');
CREATE TYPE payment_method AS ENUM ('card', 'bank_transfer', 'e_wallet');
CREATE TYPE payment_gateway AS ENUM ('stripe', 'midtrans');
CREATE TYPE transaction_status AS ENUM ('pending', 'processing', 'completed', 'failed', 'refunded');
CREATE TYPE escrow_status AS ENUM ('held', 'released', 'refunded');
CREATE TYPE reviewer_type AS ENUM ('klien', 'seniman');
CREATE TYPE notification_type AS ENUM ('project_invite', 'proposal_accepted', 'payment_received', 'review_posted', 'message_received', 'project_update');

-- Table: users
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  user_type user_type NOT NULL,
  first_name TEXT,
  last_name TEXT,
  profile_picture_url TEXT,
  phone TEXT,
  is_verified BOOLEAN DEFAULT false,
  email_verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_user_type ON users(user_type);
CREATE INDEX IF NOT EXISTS idx_users_deleted_at ON users(deleted_at);

-- Table: seniman_profiles
CREATE TABLE IF NOT EXISTS seniman_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  bio TEXT,
  lokasi TEXT,
  kategori JSONB DEFAULT '[]'::jsonb,
  rate_per_hour DECIMAL(10,2),
  rate_per_project DECIMAL(10,2),
  rating_average DECIMAL(3,2) DEFAULT 0,
  total_reviews INTEGER DEFAULT 0,
  total_projects_completed INTEGER DEFAULT 0,
  response_time_hours INTEGER DEFAULT 24,
  portfolio_count INTEGER DEFAULT 0,
  years_experience INTEGER DEFAULT 0,
  availability_status availability_status DEFAULT 'available',
  verification_status verification_status DEFAULT 'unverified',
  is_featured BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_seniman_user_id ON seniman_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_seniman_rating ON seniman_profiles(rating_average DESC);
CREATE INDEX IF NOT EXISTS idx_seniman_verification ON seniman_profiles(verification_status);
CREATE INDEX IF NOT EXISTS idx_seniman_featured ON seniman_profiles(is_featured);

-- Table: klien_profiles
CREATE TABLE IF NOT EXISTS klien_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  company_name TEXT,
  company_description TEXT,
  company_website TEXT,
  company_size company_size DEFAULT 'personal',
  industry TEXT,
  total_projects_posted INTEGER DEFAULT 0,
  total_spent DECIMAL(12,2) DEFAULT 0,
  rating_as_buyer DECIMAL(3,2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_klien_user_id ON klien_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_klien_industry ON klien_profiles(industry);

-- Table: portfolio_items
CREATE TABLE IF NOT EXISTS portfolio_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  seniman_id UUID NOT NULL REFERENCES seniman_profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT,
  image_urls JSONB DEFAULT '[]'::jsonb,
  video_url TEXT,
  project_date DATE,
  client_name TEXT,
  tools_used JSONB DEFAULT '[]'::jsonb,
  is_featured BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_portfolio_seniman ON portfolio_items(seniman_id);
CREATE INDEX IF NOT EXISTS idx_portfolio_category ON portfolio_items(category);
CREATE INDEX IF NOT EXISTS idx_portfolio_featured ON portfolio_items(is_featured);

-- Table: projects
CREATE TABLE IF NOT EXISTS projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  klien_id UUID NOT NULL REFERENCES klien_profiles(id) ON DELETE CASCADE,
  seniman_id UUID REFERENCES seniman_profiles(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  budget DECIMAL(12,2) NOT NULL,
  budget_type budget_type DEFAULT 'fixed',
  status project_status DEFAULT 'draft',
  start_date DATE,
  deadline DATE,
  estimated_duration_days INTEGER,
  required_skills JSONB DEFAULT '[]'::jsonb,
  attachments JSONB DEFAULT '[]'::jsonb,
  klien_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_projects_klien ON projects(klien_id);
CREATE INDEX IF NOT EXISTS idx_projects_seniman ON projects(seniman_id);
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(status);
CREATE INDEX IF NOT EXISTS idx_projects_category ON projects(category);
CREATE INDEX IF NOT EXISTS idx_projects_created ON projects(created_at DESC);

-- Table: project_proposals
CREATE TABLE IF NOT EXISTS project_proposals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  seniman_id UUID NOT NULL REFERENCES seniman_profiles(id) ON DELETE CASCADE,
  proposed_budget DECIMAL(12,2) NOT NULL,
  proposed_timeline_days INTEGER,
  cover_letter TEXT,
  status proposal_status DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(project_id, seniman_id)
);

CREATE INDEX IF NOT EXISTS idx_proposals_project ON project_proposals(project_id);
CREATE INDEX IF NOT EXISTS idx_proposals_seniman ON project_proposals(seniman_id);
CREATE INDEX IF NOT EXISTS idx_proposals_status ON project_proposals(status);

-- Table: transactions
CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  klien_id UUID NOT NULL REFERENCES klien_profiles(id) ON DELETE CASCADE,
  seniman_id UUID NOT NULL REFERENCES seniman_profiles(id) ON DELETE CASCADE,
  amount DECIMAL(12,2) NOT NULL,
  currency TEXT DEFAULT 'IDR',
  payment_method payment_method,
  payment_gateway payment_gateway,
  gateway_transaction_id TEXT,
  status transaction_status DEFAULT 'pending',
  escrow_status escrow_status DEFAULT 'held',
  fee_percentage DECIMAL(5,2) DEFAULT 10,
  platform_fee DECIMAL(12,2),
  net_amount DECIMAL(12,2),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_transactions_project ON transactions(project_id);
CREATE INDEX IF NOT EXISTS idx_transactions_klien ON transactions(klien_id);
CREATE INDEX IF NOT EXISTS idx_transactions_seniman ON transactions(seniman_id);
CREATE INDEX IF NOT EXISTS idx_transactions_status ON transactions(status);

-- Table: reviews
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  reviewer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reviewee_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reviewer_type reviewer_type NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  professionalism INTEGER CHECK (professionalism >= 1 AND professionalism <= 5),
  quality_of_work INTEGER CHECK (quality_of_work >= 1 AND quality_of_work <= 5),
  communication INTEGER CHECK (communication >= 1 AND communication <= 5),
  timeliness INTEGER CHECK (timeliness >= 1 AND timeliness <= 5),
  would_hire_again BOOLEAN,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(project_id, reviewer_id)
);

CREATE INDEX IF NOT EXISTS idx_reviews_reviewee ON reviews(reviewee_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating DESC);
CREATE INDEX IF NOT EXISTS idx_reviews_project ON reviews(project_id);

-- Table: messages
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
  sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  receiver_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  message TEXT NOT NULL,
  attachment_urls JSONB DEFAULT '[]'::jsonb,
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_messages_sender_receiver ON messages(sender_id, receiver_id);
CREATE INDEX IF NOT EXISTS idx_messages_project ON messages(project_id);
CREATE INDEX IF NOT EXISTS idx_messages_is_read ON messages(is_read);
CREATE INDEX IF NOT EXISTS idx_messages_created ON messages(created_at DESC);

-- Table: notifications
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type notification_type NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  related_id UUID,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created ON notifications(created_at DESC);

-- Table: admin_logs
CREATE TABLE IF NOT EXISTS admin_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  old_values JSONB,
  new_values JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_admin_logs_admin ON admin_logs(admin_id);
CREATE INDEX IF NOT EXISTS idx_admin_logs_entity ON admin_logs(entity_type, entity_id);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE seniman_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE klien_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_logs ENABLE ROW LEVEL SECURITY;

-- RLS Policies for users
CREATE POLICY "Users can view their own profile"
  ON users FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON users FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- RLS Policies for seniman_profiles
CREATE POLICY "Anyone can view seniman profiles"
  ON seniman_profiles FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Seniman can create their own profile"
  ON seniman_profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Seniman can update their own profile"
  ON seniman_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- RLS Policies for klien_profiles
CREATE POLICY "Klien can view their own profile"
  ON klien_profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Klien can create their own profile"
  ON klien_profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Klien can update their own profile"
  ON klien_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- RLS Policies for portfolio_items
CREATE POLICY "Anyone can view portfolio items"
  ON portfolio_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Seniman can create portfolio items"
  ON portfolio_items FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM seniman_profiles
      WHERE seniman_profiles.id = portfolio_items.seniman_id
      AND seniman_profiles.user_id = auth.uid()
    )
  );

CREATE POLICY "Seniman can update their portfolio items"
  ON portfolio_items FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM seniman_profiles
      WHERE seniman_profiles.id = portfolio_items.seniman_id
      AND seniman_profiles.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM seniman_profiles
      WHERE seniman_profiles.id = portfolio_items.seniman_id
      AND seniman_profiles.user_id = auth.uid()
    )
  );

CREATE POLICY "Seniman can delete their portfolio items"
  ON portfolio_items FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM seniman_profiles
      WHERE seniman_profiles.id = portfolio_items.seniman_id
      AND seniman_profiles.user_id = auth.uid()
    )
  );

-- RLS Policies for projects
CREATE POLICY "Authenticated users can view projects"
  ON projects FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Klien can create projects"
  ON projects FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM klien_profiles
      WHERE klien_profiles.id = projects.klien_id
      AND klien_profiles.user_id = auth.uid()
    )
  );

CREATE POLICY "Klien can update their projects"
  ON projects FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM klien_profiles
      WHERE klien_profiles.id = projects.klien_id
      AND klien_profiles.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM klien_profiles
      WHERE klien_profiles.id = projects.klien_id
      AND klien_profiles.user_id = auth.uid()
    )
  );

CREATE POLICY "Klien can delete their projects"
  ON projects FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM klien_profiles
      WHERE klien_profiles.id = projects.klien_id
      AND klien_profiles.user_id = auth.uid()
    )
  );

-- RLS Policies for project_proposals
CREATE POLICY "Users can view proposals for their projects"
  ON project_proposals FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM seniman_profiles
      WHERE seniman_profiles.id = project_proposals.seniman_id
      AND seniman_profiles.user_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1 FROM projects
      JOIN klien_profiles ON projects.klien_id = klien_profiles.id
      WHERE projects.id = project_proposals.project_id
      AND klien_profiles.user_id = auth.uid()
    )
  );

CREATE POLICY "Seniman can create proposals"
  ON project_proposals FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM seniman_profiles
      WHERE seniman_profiles.id = project_proposals.seniman_id
      AND seniman_profiles.user_id = auth.uid()
    )
  );

CREATE POLICY "Seniman can update their proposals"
  ON project_proposals FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM seniman_profiles
      WHERE seniman_profiles.id = project_proposals.seniman_id
      AND seniman_profiles.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM seniman_profiles
      WHERE seniman_profiles.id = project_proposals.seniman_id
      AND seniman_profiles.user_id = auth.uid()
    )
  );

-- RLS Policies for transactions
CREATE POLICY "Users can view their transactions"
  ON transactions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM klien_profiles
      WHERE klien_profiles.id = transactions.klien_id
      AND klien_profiles.user_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1 FROM seniman_profiles
      WHERE seniman_profiles.id = transactions.seniman_id
      AND seniman_profiles.user_id = auth.uid()
    )
  );

-- RLS Policies for reviews
CREATE POLICY "Anyone can view reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create reviews"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = reviewer_id);

CREATE POLICY "Users can update their reviews"
  ON reviews FOR UPDATE
  TO authenticated
  USING (auth.uid() = reviewer_id)
  WITH CHECK (auth.uid() = reviewer_id);

CREATE POLICY "Users can delete their reviews"
  ON reviews FOR DELETE
  TO authenticated
  USING (auth.uid() = reviewer_id);

-- RLS Policies for messages
CREATE POLICY "Users can view their messages"
  ON messages FOR SELECT
  TO authenticated
  USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

CREATE POLICY "Users can send messages"
  ON messages FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Users can update their received messages"
  ON messages FOR UPDATE
  TO authenticated
  USING (auth.uid() = receiver_id)
  WITH CHECK (auth.uid() = receiver_id);

-- RLS Policies for notifications
CREATE POLICY "Users can view their notifications"
  ON notifications FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their notifications"
  ON notifications FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their notifications"
  ON notifications FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- RLS Policies for admin_logs (admin only)
CREATE POLICY "Only admins can view admin logs"
  ON admin_logs FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.user_type = 'admin'
    )
  );

CREATE POLICY "Only admins can create admin logs"
  ON admin_logs FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.user_type = 'admin'
    )
  );