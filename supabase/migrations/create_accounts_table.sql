-- ==============================================================================
-- Xenobill Supabase Database - accounts Table DDL Script
-- Target: Supabase SQL Editor
-- Table: public.accounts
-- ==============================================================================

-- 1. Create accounts table matching the application model schema
CREATE TABLE IF NOT EXISTS public.accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    owner_name TEXT,
    email TEXT,
    whatsapp_number TEXT,
    is_gst_registered BOOLEAN DEFAULT false,
    gst_number TEXT,
    address_line_1 TEXT,
    address_line_2 TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    last_used_at TIMESTAMPTZ DEFAULT now(),
    status TEXT DEFAULT 'active',
    updated_at TIMESTAMPTZ DEFAULT now(),
    business_name TEXT,
    business_type TEXT,
    phone TEXT
);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies
CREATE POLICY "Users can view their own account" 
    ON public.accounts FOR SELECT 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own account" 
    ON public.accounts FOR UPDATE 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own account" 
    ON public.accounts FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Service role / Admin access policy
CREATE POLICY "Service role full access" 
    ON public.accounts FOR ALL 
    USING (auth.role() = 'service_role');

-- 4. Trigger for automatic updated_at timestamp updates
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_accounts_updated
    BEFORE UPDATE ON public.accounts
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- 5. RPC function to check if email exists in auth.users or public.accounts
CREATE OR REPLACE FUNCTION public.check_email_exists(p_email TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM auth.users WHERE lower(email) = lower(p_email)
        UNION
        SELECT 1 FROM public.accounts WHERE lower(email) = lower(p_email)
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Trigger for automatic account row creation from auth.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
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

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


