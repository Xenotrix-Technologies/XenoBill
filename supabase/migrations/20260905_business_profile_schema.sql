-- ==============================================================================
-- Xenobiz Business Profile Database Migration Script
-- Target: Supabase PostgreSQL Database
-- ==============================================================================

-- 1. Create Trigger Function for Automatic `updated_at` Column Updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Create Accounts Table
CREATE TABLE IF NOT EXISTS public.accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    primary_business_id UUID NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Create Businesses Table
CREATE TABLE IF NOT EXISTS public.businesses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
    business_name TEXT NOT NULL,
    business_type TEXT NULL,
    phone TEXT NULL,
    alternate_phone TEXT NULL,
    email TEXT NULL,
    address TEXT NULL,
    city TEXT NULL,
    state TEXT NULL,
    country TEXT NULL,
    pin_code TEXT NULL,
    gst_registration_type TEXT NULL,
    gstin TEXT NULL,
    pan TEXT NULL,
    logo_url TEXT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    client_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Add Circular Foreign Key Constraint on Accounts Table
ALTER TABLE public.accounts
    ADD CONSTRAINT fk_accounts_primary_business
    FOREIGN KEY (primary_business_id) REFERENCES public.businesses(id)
    ON DELETE SET NULL;

-- 5. Performance Indexes
CREATE INDEX IF NOT EXISTS idx_accounts_user_id ON public.accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_businesses_account_id ON public.businesses(account_id);

-- 6. Attach Updated_At Triggers
DROP TRIGGER IF EXISTS set_accounts_updated_at ON public.accounts;
CREATE TRIGGER set_accounts_updated_at
    BEFORE UPDATE ON public.accounts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS set_businesses_updated_at ON public.businesses;
CREATE TRIGGER set_businesses_updated_at
    BEFORE UPDATE ON public.businesses
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) & POLICIES
-- ==============================================================================

-- 7. Enable RLS
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.businesses ENABLE ROW LEVEL SECURITY;

-- 8. Accounts RLS Policies
CREATE POLICY "Users can view their own account"
    ON public.accounts FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own account"
    ON public.accounts FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own account"
    ON public.accounts FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own account"
    ON public.accounts FOR DELETE
    USING (auth.uid() = user_id);

-- 9. Businesses RLS Policies
CREATE POLICY "Users can view businesses belonging to their account"
    ON public.businesses FOR SELECT
    USING (account_id IN (SELECT id FROM public.accounts WHERE user_id = auth.uid()));

CREATE POLICY "Users can insert businesses for their account"
    ON public.businesses FOR INSERT
    WITH CHECK (account_id IN (SELECT id FROM public.accounts WHERE user_id = auth.uid()));

CREATE POLICY "Users can update businesses belonging to their account"
    ON public.businesses FOR UPDATE
    USING (account_id IN (SELECT id FROM public.accounts WHERE user_id = auth.uid()));

CREATE POLICY "Users can delete businesses belonging to their account"
    ON public.businesses FOR DELETE
    USING (account_id IN (SELECT id FROM public.accounts WHERE user_id = auth.uid()));
