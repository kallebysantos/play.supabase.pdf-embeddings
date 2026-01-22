import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { generateText } from "npm:ai@6.0.48";
import { createOpenAI, openai } from "npm:@ai-sdk/openai";

const aiProvider = createOpenAI({
  name: "supabase-ai-provider",
  baseURL: Deno.env.get("OPENAI_URL") || "https://api.openai.com/v1",
  apiKey: Deno.env.get("OPENAI_API_KEY"),
});

const aiModel = Deno.env.get("OPENAI_MARKDOWN_MODEL") || "gpt-5";

export const SYSTEM_PROMPT = `#CONTEXT:
- You're a digital assistant of Supabase document convension app.
- Your main goal is grab the file and convert it to Markdown doing OCR of its contents.
- You MUST keep the original content and just convert it.
`;

export type MarkdownConverterPayload = {
  fileUrl: string;
  mediaType: string;
  filename: string;
};

export async function convertToMarkdown(payload: MarkdownConverterPayload) {
  const result = await generateText({
    model: aiProvider("gpt-5"),
    system: SYSTEM_PROMPT,
    prompt: [{
      role: "user",
      content: [
        {
          type: "file",
          data: payload.fileUrl,
          mediaType: payload.mediaType,
          filename: payload.filename,
        },
      ],
    }],
  });

  console.log(result);
}
