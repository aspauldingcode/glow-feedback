# Discord-GitHub Bot Setup Guide

## Required Environment Variables

You'll need to set up these environment variables in Vercel:

### Discord Configuration
- `DISCORD_TOKEN`: Your Discord bot token (from Discord Developer Portal)
- `DISCORD_CHANNEL_ID`: The Discord channel ID where issues will be posted

### GitHub Configuration  
- `GITHUB_ACCESS_TOKEN`: Your GitHub personal access token
- `GITHUB_USERNAME`: aspauldingcode
- `GITHUB_REPOSITORY`: glow-feedback

## Setup Steps

### 1. Discord Bot Setup
1. Go to https://discord.com/developers/applications
2. Create a new application
3. Go to "Bot" section and create a bot
4. Copy the bot token for `DISCORD_TOKEN`
5. Set bot permissions: Send Messages, Manage Messages, Manage Threads, Read Message History
6. Invite bot to your Discord server using OAuth2 URL Generator

### 2. GitHub Token Setup
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Generate a new token with `repo` scope
3. Copy the token for `GITHUB_ACCESS_TOKEN`

### 3. Discord Channel ID
1. Enable Developer Mode in Discord (User Settings → Advanced)
2. Right-click on your target channel and "Copy ID"
3. Use this for `DISCORD_CHANNEL_ID`

### 4. Deploy to Vercel
```bash
# Add environment variables
vercel env add DISCORD_TOKEN
vercel env add DISCORD_CHANNEL_ID  
vercel env add GITHUB_ACCESS_TOKEN

# Deploy
vercel deploy --prod
```

### 5. Configure GitHub Webhook
After deployment, add a webhook in your GitHub repository:
- URL: `https://your-vercel-url.vercel.app/webhook/github`
- Content type: `application/json`
- Events: Issues, Issue comments, Pull requests