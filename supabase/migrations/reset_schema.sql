-- ==============================================================================
-- Xenobill Supabase Database Reset / Cleanup Script
-- Target: Supabase SQL Editor
-- Purpose: Remove all tables, views, functions & data in `public` schema
-- Preserves: Supabase Initialization, Auth (auth.users), and Storage
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- METHOD 1: Complete Public Schema Wipe & Reset (Recommended)
-- ------------------------------------------------------------------------------

-- 1. Drop public schema with all tables, views, triggers & functions cascade
DROP SCHEMA public CASCADE;

-- 2. Recreate fresh public schema
CREATE SCHEMA public;

-- 3. Restore standard Supabase default permissions
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO anon;
GRANT ALL ON SCHEMA public TO authenticated;
GRANT ALL ON SCHEMA public TO service_role;

GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres, anon, authenticated, service_role;

-- ------------------------------------------------------------------------------
-- METHOD 2: Explicit Individual Object Cleanup (Alternative)
-- ------------------------------------------------------------------------------
/*
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

DROP VIEW IF EXISTS public.companies CASCADE;

DROP TABLE IF EXISTS public.admin_audit_logs CASCADE;
DROP TABLE IF EXISTS public.admin_users CASCADE;
DROP TABLE IF EXISTS public.subscription_plans CASCADE;
DROP TABLE IF EXISTS public.subscriptions CASCADE;
DROP TABLE IF EXISTS public.invoice_items CASCADE;
DROP TABLE IF EXISTS public.invoices CASCADE;
DROP TABLE IF EXISTS public.expenses CASCADE;
DROP TABLE IF EXISTS public.products CASCADE;
DROP TABLE IF EXISTS public.items CASCADE;
DROP TABLE IF EXISTS public.customers CASCADE;
DROP TABLE IF EXISTS public.businesses CASCADE;
DROP TABLE IF EXISTS public.accounts CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;

DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;
DROP FUNCTION IF EXISTS public.is_super_admin() CASCADE;
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;
*/
