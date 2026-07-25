-- Update public.profiles to include new fields if they do not exist

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='dob') THEN
        ALTER TABLE public.profiles ADD COLUMN dob DATE;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='address') THEN
        ALTER TABLE public.profiles ADD COLUMN address TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='city') THEN
        ALTER TABLE public.profiles ADD COLUMN city TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='state') THEN
        ALTER TABLE public.profiles ADD COLUMN state TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='country') THEN
        ALTER TABLE public.profiles ADD COLUMN country TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='avatar_url') THEN
        ALTER TABLE public.profiles ADD COLUMN avatar_url TEXT;
    END IF;
END $$;

-- Create Storage bucket for avatars if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
SELECT 'avatars', 'avatars', true
WHERE NOT EXISTS (
    SELECT 1 FROM storage.buckets WHERE id = 'avatars'
);



-- Storage Policies for 'avatars' bucket (if not already existing)

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'Avatar images are publicly accessible.'
    ) THEN
        CREATE POLICY "Avatar images are publicly accessible."
            ON storage.objects FOR SELECT
            USING ( bucket_id = 'avatars' );
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'Users can upload their own avatars.'
    ) THEN
        CREATE POLICY "Users can upload their own avatars."
            ON storage.objects FOR INSERT
            WITH CHECK ( bucket_id = 'avatars' AND auth.uid() = owner );
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'Users can update their own avatars.'
    ) THEN
        CREATE POLICY "Users can update their own avatars."
            ON storage.objects FOR UPDATE
            USING ( bucket_id = 'avatars' AND auth.uid() = owner );
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'Users can delete their own avatars.'
    ) THEN
        CREATE POLICY "Users can delete their own avatars."
            ON storage.objects FOR DELETE
            USING ( bucket_id = 'avatars' AND auth.uid() = owner );
    END IF;
END $$;
