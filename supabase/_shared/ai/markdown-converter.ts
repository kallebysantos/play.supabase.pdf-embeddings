import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { generateText } from "npm:ai@6.0.48";
// import { createOpenAI } from "npm:@ai-sdk/openai";
import { createGoogleGenerativeAI } from "npm:@ai-sdk/google";

/*
const aiProvider = createOpenAI({
  name: "supabase-ai-provider",
  baseURL: Deno.env.get("OPENAI_URL") || "https://api.openai.com/v1",
  apiKey: Deno.env.get("OPENAI_API_KEY"),
});
*/
const aiProvider = createGoogleGenerativeAI({
  name: "supabase-ai-provider",
  apiKey: Deno.env.get("GEMINI_API_KEY"),
});

const aiModel = Deno.env.get("OPENAI_MARKDOWN_MODEL") || "gemini-2.5-flash";

export const SYSTEM_PROMPT = `#CONTEXT:
- You're a digital assistant of Supabase document convension app.
- Your main goal is grab the file and convert it to Markdown doing OCR of its contents.
- You MUST keep the original content and just convert it.
`;

export type MarkdownConverterPayload = {
  data: string | Blob;
  mediaType: string;
  filename?: string;
};

export async function convertToMarkdown(payload: MarkdownConverterPayload) {
  console.log(payload);

  const result = await generateText({
    model: aiProvider(aiModel),
    system: SYSTEM_PROMPT,
    prompt: [{
      role: "user",
      content: [
        {
          type: "file",
          data: (typeof payload.data === "string")
            ? payload.data
            : await payload.data.arrayBuffer(),
          mediaType: payload.mediaType,
          filename: payload.filename,
        },
      ],
    }],
  });

  return result.text;
}
