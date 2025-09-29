{
  description = "Discord-GitHub Issues Bot with Vercel deployment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_20
            pnpm
            nodePackages.vercel
            git
            curl
            jq
          ];

          shellHook = ''
            echo "🚀 Discord-GitHub Issues Bot Development Environment"
            echo ""
            
            # Function to check if Vercel is logged in
            check_vercel_login() {
              if ! vercel whoami >/dev/null 2>&1; then
                echo "❌ Not logged in to Vercel. Please run: vercel login"
                return 1
              fi
              echo "✅ Logged in to Vercel as: $(vercel whoami)"
              return 0
            }
            
            # Function to check if environment variable exists in Vercel
            check_env_var() {
              local var_name=$1
              if vercel env ls | grep -q "^$var_name"; then
                return 0
              else
                return 1
              fi
            }
            
            # Function to add environment variable if it doesn't exist
            add_env_var_if_missing() {
              local var_name=$1
              local description=$2
              
              if ! check_env_var "$var_name"; then
                echo "❌ Missing environment variable: $var_name"
                echo "📝 $description"
                echo "Please add it manually with: vercel env add $var_name"
                echo ""
              else
                echo "✅ Environment variable $var_name exists"
              fi
            }
            
            # Function to setup .env file
            setup_env_file() {
              if [ ! -f .env ] && [ ! -f .env.local ]; then
                echo "📥 Pulling environment variables from Vercel..."
                if vercel env pull .env.local 2>/dev/null; then
                  echo "✅ Created .env.local file"
                else
                  echo "❌ Failed to pull environment variables. Make sure all variables are set in Vercel."
                fi
              else
                echo "✅ Environment file already exists"
              fi
            }
            
            echo "🔐 Checking Vercel authentication..."
            if check_vercel_login; then
              echo ""
              echo "🔍 Checking required environment variables..."
              add_env_var_if_missing "DISCORD_TOKEN" "Your Discord bot token from https://discord.com/developers/applications"
              add_env_var_if_missing "DISCORD_CHANNEL_ID" "Discord channel ID (right-click channel → Copy ID)"
              add_env_var_if_missing "GITHUB_ACCESS_TOKEN" "GitHub personal access token with 'repo' scope"
              
              echo ""
              setup_env_file
            fi
            
            echo ""
            echo "🛠️  Available Commands:"
            echo "  pnpm install          - Install dependencies"
            echo "  pnpm dev              - Start development server"
            echo "  pnpm build            - Build for production"
            echo "  vercel dev            - Local development with Vercel"
            echo "  vercel deploy         - Deploy to production"
            echo "  vercel env add        - Add environment variables"
            echo "  vercel env pull       - Pull environment variables to .env.local"
            echo ""
            echo "📦 Installing dependencies..."
            pnpm install
            
            echo ""
            echo "🔨 Building project..."
            pnpm build
            
            if [ -d "dist" ]; then
              echo "✅ Build completed successfully - dist directory created"
            else
              echo "❌ Build failed - dist directory not found"
            fi
          '';

          # Environment variables for development
          VERCEL_ORG_ID = "";
          VERCEL_PROJECT_ID = "";
        };

        # Optional: Add packages for direct installation
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "discord-github-bot";
          version = "1.0.0";
          src = ./.;
          
          buildInputs = with pkgs; [ nodejs_20 pnpm ];
          
          buildPhase = ''
            pnpm install
            pnpm build
          '';
          
          installPhase = ''
            mkdir -p $out
            cp -r dist/* $out/
          '';
        };
      });
}