import {createClient} from '@supabase/supabase-js';

export const supabase = createClient('https://supabase.journeyplanner.io', import.meta.env.VITE_SUPABASEKEY)
