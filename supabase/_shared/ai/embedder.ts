import {
  env,
  pipeline,
} from "https://cdn.jsdelivr.net/npm/@huggingface/transformers@3.8.1";
import { getConfig } from "../supabase/config.ts";

// Ensure we do use browser cache,
// in order to apply the latest fetch optimizations features
env.useBrowserCache = true;
env.allowLocalModels = false;

const config = getConfig();

// We do not await here for lazy loading
export const embedder = pipeline(
  "feature-extraction",
  "Supabase/gte-small",
  {
    device: "auto",
  },
);

export type EmbedInput = {
  text: string;
};

export type EmbedOutput = {
  data: number[];
  length: number;
};

/** Uses an external EdgeFunction endpoint to perform inference */
export async function embed(payload: EmbedInput) {
  if (typeof config === "string") throw new Error(config);

  const { supabaseUrl, sbPublishableKey } = config;

  const embeddings = await fetch(`${supabaseUrl}/functions/v1/embedder`, {
    method: "POST",
    body: JSON.stringify(payload),
    headers: {
      Authorization: `Bearer ${sbPublishableKey}`,
      "Content-Type": "application/json",
    },
  });

  const result: EmbedOutput = await embeddings.json();

  return result;
}
