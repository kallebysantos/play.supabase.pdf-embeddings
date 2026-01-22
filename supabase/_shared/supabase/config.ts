// These are automatically injected
const supabaseUrl = Deno.env.get("SUPABASE_URL");
const sbPublishableKey = Deno.env.get("SB_PUBLISHABLE_KEY");
const sbSecretKey = Deno.env.get("SB_SECRET_KEY");

export function getConfig() {
  if (
    !supabaseUrl || !sbPublishableKey || !sbSecretKey
  ) {
    return MissingConfigError;
  }

  return {
    supabaseUrl,
    sbPublishableKey,
    sbSecretKey,
  };
}

export const IS_LOCAL_ENV = supabaseUrl?.startsWith("http://kong:8000") ??
  false;

export const MissingConfigError =
  "Missing 'SUPABASE_*', 'SB_*' environment config";
