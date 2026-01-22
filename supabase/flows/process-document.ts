import { Flow } from "@pgflow/dsl";

type Input = {
  documentId: string;
};

export const ProcessDocuments = new Flow<Input>({
  slug: "processDocuments",
})
  .step(
    { slug: "toMarkdown" },
    (flowInput) => {
      console.log(`processing: ${flowInput.documentId}`);
    },
  );
