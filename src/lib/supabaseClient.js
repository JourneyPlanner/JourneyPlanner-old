import {createClient} from '@supabase/supabase-js';

export const supabase = createClient('https://supabase.journeyplanner.io', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNjk5NzQzNjAwLAogICJleHAiOiAxODU3NTk2NDAwCn0.XVENSoSK-5LZ7bFLq0qWee5KNuK6XJ6fE7XS9fvT_VA')
