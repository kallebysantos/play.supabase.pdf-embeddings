import { EdgeWorker } from "@pgflow/edge-worker";
import { ProcessDocuments } from "../../flows/process-document.ts";

EdgeWorker.start(ProcessDocuments);
