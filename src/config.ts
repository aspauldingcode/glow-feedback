import dotenv from "dotenv";

dotenv.config();

// Function to get and validate config when needed
export function getConfig() {
  const {
    DISCORD_TOKEN,
    GITHUB_ACCESS_TOKEN,
    GITHUB_USERNAME,
    GITHUB_REPOSITORY,
    DISCORD_CHANNEL_ID,
  } = process.env;

  if (
    !DISCORD_TOKEN ||
    !GITHUB_ACCESS_TOKEN ||
    !GITHUB_USERNAME ||
    !GITHUB_REPOSITORY ||
    !DISCORD_CHANNEL_ID
  ) {
    throw new Error("Missing environment variables");
  }

  return {
    DISCORD_TOKEN,
    GITHUB_ACCESS_TOKEN,
    GITHUB_USERNAME,
    GITHUB_REPOSITORY,
    DISCORD_CHANNEL_ID,
  };
}

// For backward compatibility, export config but make it lazy
export const config = new Proxy({} as any, {
  get(target, prop) {
    return getConfig()[prop as keyof ReturnType<typeof getConfig>];
  }
});
