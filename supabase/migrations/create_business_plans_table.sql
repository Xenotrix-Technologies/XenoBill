-- ==============================================================================
-- Xenobill Supabase Database - business_plans Table & Registration Trigger Script
-- Target: Supabase SQL Editor
-- Table: public.business_plans
-- ==============================================================================

-- 1. Create public.business_plans table matching user plan & subscription schema
CREATE TABLE IF NOT EXISTS public.business_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
    plan_id UUID,
    plan_name TEXT DEFAULT 'Demo Plan',
    company_name TEXT,
    current_plan_price NUMERIC(10, 2) DEFAULT 0.00,
    billing_cycle TEXT DEFAULT 'demo',
    currency TEXT DEFAULT 'INR',
    plan_details JSONB DEFAULT '{}'::jsonb,
    is_demo_user BOOLEAN DEFAULT true,
    demo_status TEXT DEFAULT 'running',
    demo_start_at TIMESTAMPTZ DEFAULT now(),
    demo_end_at TIMESTAMPTZ DEFAULT (now() + interval '30 days'),
    subscription_status TEXT DEFAULT 'demo',
    purchase_date TIMESTAMPTZ,
    start_date TIMESTAMPTZ DEFAULT now(),
    due_date TIMESTAMPTZ DEFAULT (now() + interval '30 days'),
    auto_renew BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    subscription_source TEXT,
    gateway TEXT,
    gateway_customer_id TEXT,
    gateway_subscription_id TEXT,
    CONSTRAINT check_demo_status CHECK (demo_status = ANY (ARRAY['not_started'::text, 'running'::text, 'expired'::text, 'cancelled'::text])),
    CONSTRAINT check_gateway CHECK (gateway IS NULL OR (gateway = ANY (ARRAY['razorpay'::text, 'cashfree'::text, 'manual'::text])))
);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE public.business_plans ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies
CREATE POLICY "Users can view their own business_plan" 
    ON public.business_plans FOR SELECT 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own business_plan" 
    ON public.business_plans FOR UPDATE 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own business_plan" 
    ON public.business_plans FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Service role full access policy
CREATE POLICY "Service role full access on business_plans" 
    ON public.business_plans FOR ALL 
    USING (auth.role() = 'service_role');

-- 4. Updated handle_new_user() trigger function inserting into public.accounts AND public.business_plans
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- A. Insert or update public.accounts
  INSERT INTO public.accounts (
    id, 
    user_id, 
    owner_name,
    email, 
    phone, 
    whatsapp_number,
    business_name,
    business_type,
    address_line_1,
    address_line_2,
    status, 
    created_at, 
    updated_at
  )
  VALUES (
    gen_random_uuid(),
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data->>'owner_name',
      NEW.raw_user_meta_data->>'full_name',
      NEW.raw_user_meta_data->>'name',
      NEW.raw_user_meta_data->>'username',
      split_part(NEW.email, '@', 1)
    ),
    NEW.email,
    COALESCE(NEW.phone, NEW.raw_user_meta_data->>'phone'),
    COALESCE(NEW.raw_user_meta_data->>'whatsapp_number', NEW.phone, NEW.raw_user_meta_data->>'phone'),
    NEW.raw_user_meta_data->>'business_name',
    NEW.raw_user_meta_data->>'business_type',
    NEW.raw_user_meta_data->>'address_line_1',
    NEW.raw_user_meta_data->>'address_line_2',
    'active',
    NOW(),
    NOW()
  )
  ON CONFLICT (user_id) DO UPDATE SET
    owner_name = COALESCE(EXCLUDED.owner_name, accounts.owner_name),
    phone = COALESCE(EXCLUDED.phone, accounts.phone),
    whatsapp_number = COALESCE(EXCLUDED.whatsapp_number, accounts.whatsapp_number),
    business_name = COALESCE(EXCLUDED.business_name, accounts.business_name),
    business_type = COALESCE(EXCLUDED.business_type, accounts.business_type),
    address_line_1 = COALESCE(EXCLUDED.address_line_1, accounts.address_line_1),
    address_line_2 = COALESCE(EXCLUDED.address_line_2, accounts.address_line_2),
    email = EXCLUDED.email,
    updated_at = NOW();

  -- B. Insert initial demo plan row into public.business_plans
  INSERT INTO public.business_plans (
    id,
    user_id,
    plan_name,
    company_name,
    current_plan_price,
    billing_cycle,
    currency,
    plan_details,
    is_demo_user,
    demo_status,
    demo_start_at,
    demo_end_at,
    subscription_status,
    start_date,
    due_date,
    auto_renew,
    created_at,
    updated_at
  )
  VALUES (
    gen_random_uuid(),
    NEW.id,
    'Demo Plan',
    NEW.raw_user_meta_data->>'business_name',
    0.00,
    'demo',
    'INR',
    '{}'::jsonb,
    true,
    'running',
    NOW(),
    NOW() + INTERVAL '30 days',
    'demo',
    NOW(),
    NOW() + INTERVAL '30 days',
    false,
    NOW(),
    NOW()
  )
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Trigger binding on auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
