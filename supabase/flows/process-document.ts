import { Flow } from "@pgflow/dsl";
import {
  convertToMarkdown,
  MarkdownConverterPayload,
} from "../_shared/ai/markdown-converter.ts";
import { getDatabase } from "../_shared/supabase/service.ts";
import { IS_LOCAL_ENV } from "../_shared/supabase/config.ts";

const db = getDatabase({ serviceRole: true });
if (typeof db === "string") throw new Error(db);

type Input = {
  documentId: string;
};

export const ProcessDocuments = new Flow<Input>({
  slug: "processDocuments",
})
  .step(
    { slug: "toMarkdown" },
    async (flowInput) => {
      try {
        const { data: getDocumentResult, error: getDocumentError } = await db
          .from("documents_with_storage_path")
          .select("storage_object_path")
          .eq("id", flowInput.documentId)
          .single();

        if (!getDocumentResult?.storage_object_path || getDocumentError) {
          console.error("getDocumentError", getDocumentError);
          throw new Error(
            getDocumentError?.message ||
              `could not get document with id: ${flowInput.documentId} `,
          );
        }

        let fileData: string | Blob;
        // We can't generate public storage URL
        if (IS_LOCAL_ENV) {
          const { data: file, error: downloadFileError } = await db.storage
            .from("documents")
            .download(getDocumentResult.storage_object_path);

          if (!file || downloadFileError) {
            console.error("downloadFileError", downloadFileError);
            throw new Error(
              downloadFileError?.message ||
                `could not download document file with id: ${flowInput.documentId}`,
            );
          }

          fileData = file;
        } else {
          const { data: fileUrl } = db.storage
            .from("documents")
            .getPublicUrl(getDocumentResult.storage_object_path);

          if (!fileUrl?.publicUrl) {
            console.error("publicUrl");
            throw new Error(
              `could not get document file url with id: ${flowInput.documentId}`,
            );
          }

          fileData = fileUrl.publicUrl;
        }

        const markdownContent = await convertToMarkdown({
          data: fileData,
          mediaType: "application/pdf",
        });

        const { error: updateDocumentError } = await db
          .from("documents")
          .update({
            content: markdownContent,
            updated_at: new Date().toISOString(),
          })
          .eq("id", flowInput.documentId);

        if (updateDocumentError) {
          console.error("updateDocumentError", updateDocumentError);
          throw new Error(updateDocumentError.message);
        }

        return markdownContent;
      } catch (e) {
        console.error(e);
        throw e;
      }
    },
  );
