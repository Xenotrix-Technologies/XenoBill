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
