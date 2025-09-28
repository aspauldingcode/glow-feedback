// Vercel serverless function entry point
const { initDiscord } = require('../dist/discord/discord');
const { initGithub } = require('../dist/github/github');

// Initialize Discord bot
initDiscord();

// Export the GitHub webhook handler for Vercel
module.exports = initGithub();