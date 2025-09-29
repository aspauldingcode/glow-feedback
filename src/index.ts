import { initDiscord } from "./discord/discord";
import { initGithub } from "./github/github";

// Initialize Discord bot
initDiscord();

// Export the GitHub webhook handler for Vercel
module.exports = initGithub();
