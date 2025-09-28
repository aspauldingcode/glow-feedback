import express from "express";
import { GithubHandlerFunction } from "../interfaces";
import {
  handleClosed,
  handleCreated,
  handleDeleted,
  handleLocked,
  handleOpened,
  handleReopened,
  handleUnlocked,
} from "./githubHandlers";

const app = express();
app.use(express.json());

export function initGithub() {
  // Health check endpoint
  app.get("/", (_, res) => {
    res.json({ msg: "Discord-GitHub Bot is running", status: "ok" });
  });

  // GitHub webhook endpoint
  app.get("/webhook/github", (_, res) => {
    res.json({ msg: "GitHub webhooks endpoint ready" });
  });

  const githubActions: {
    [key: string]: GithubHandlerFunction;
  } = {
    opened: (req) => handleOpened(req),
    created: (req) => handleCreated(req),
    closed: (req) => handleClosed(req),
    reopened: (req) => handleReopened(req),
    locked: (req) => handleLocked(req),
    unlocked: (req) => handleUnlocked(req),
    deleted: (req) => handleDeleted(req),
  };

  app.post("/webhook/github", async (req, res) => {
    try {
      const githubAction = githubActions[req.body.action];
      if (githubAction) {
        await githubAction(req);
      }
      res.json({ msg: "Webhook processed successfully" });
    } catch (error) {
      console.error("Webhook processing error:", error);
      res.status(500).json({ msg: "Webhook processing failed", error: (error as Error).message });
    }
  });

  // For Vercel serverless deployment, we export the app instead of listening
  if (process.env.VERCEL) {
    return app;
  }

  const PORT = process.env.PORT || 5000;
  app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📡 GitHub webhook endpoint: http://localhost:${PORT}/webhook/github`);
  });
}

export default app;
