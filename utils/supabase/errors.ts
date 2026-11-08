type SupabaseErrorLike = {
  code?: string;
  message?: string;
  details?: string | null;
};

function readError(error: unknown): SupabaseErrorLike {
  if (typeof error === 'object' && error !== null) return error as SupabaseErrorLike;
  if (error instanceof Error) return { message: error.message };
  return {};
}

/**
 * Converts low-level browser/PostgREST failures into an actionable message for
 * the UI. Never send these expected setup errors to console.error: Next.js
 * presents console errors as an in-browser error overlay during development.
 */
export function getSupabaseErrorMessage(error: unknown, resource = 'data') {
  const { code, message = '' } = readError(error);
  const normalized = message.toLowerCase();

  if (error instanceof TypeError && /failed to fetch/i.test(error.message)) {
    return 'Cannot reach Supabase. Confirm the Project URL and publishable key in .env.local, then restart the app.';
  }

  if (code === 'PGRST205' || code === '42P01' || normalized.includes('could not find the table')) {
    return `The ${resource} database is not initialized yet. Run supabase/migrations/20261108_initial_schema.sql in the Supabase SQL Editor, then refresh this page.`;
  }

  if (code === '42501' || normalized.includes('row-level security')) {
    return `You do not have permission to access ${resource}. Run the supplied Supabase migration to install the required security policies.`;
  }

  return message || `Unable to load ${resource}. Please refresh and try again.`;
}
