# R Script to publish app/API/report to Posit Connect
# Follows security and credential policies defined in deploy-to-connect

message("Initiating deployment to Posit Connect...")

# Verify rsconnect is installed
if (!requireNamespace("rsconnect", quietly = TRUE)) {
  message("rsconnect package is missing. Installing rsconnect...")
  install.packages("rsconnect", repos = "https://cloud.r-project.org")
}

library(rsconnect)

# Stage 1: Check existing registered accounts
accounts <- rsconnect::accounts()

server_url <- Sys.getenv("CONNECT_SERVER")
api_key <- Sys.getenv("CONNECT_API_KEY")
account_name <- Sys.getenv("CONNECT_ACCOUNT")
target_server <- Sys.getenv("CONNECT_SERVER_NAME")

# Stage 2: Register API key credentials only if explicitly provided in environment (CI workflow)
if (server_url != "" && api_key != "") {
  server_name <- if (nzchar(target_server)) target_server else "connect-server"
  
  message(sprintf("Registering explicit CI credentials for server '%s'...", server_name))
  tryCatch({
    rsconnect::addServer(url = server_url, name = server_name, quiet = TRUE)
  }, error = function(e) {
    message("Notice: ", e$message)
  })
  
  username <- if (nzchar(account_name)) account_name else "ci-deploy"
  tryCatch({
    rsconnect::connectApiUser(
      server = server_name,
      account = username,
      apiKey = api_key
    )
    message("User registered successfully via API key.")
  }, error = function(e) {
    message("Failed to register API user: ", e$message)
    quit(status = 1)
  })
  
  accounts <- rsconnect::accounts()
}

# Stage 3: Validate available accounts
if (is.null(accounts) || nrow(accounts) == 0) {
  message("Error: No accounts configured in rsconnect.")
  message("Follow guidelines in 'deploy-to-connect' to register your server:")
  message("  Interactive: rsconnect::addServer('<url>', name = '<name>'); rsconnect::connectUser(server = '<name>')")
  message("  Non-interactive (CI): set CONNECT_SERVER, CONNECT_API_KEY, and optional CONNECT_ACCOUNT.")
  quit(status = 1)
}

# Stage 4: Deploy application or document
app_dir <- getwd()
message("Deploying content from: ", app_dir)

tryCatch({
  # If a specific server was targeted via env var, pass it explicitly
  if (nzchar(target_server)) {
    rsconnect::deployApp(
      appDir = app_dir,
      server = target_server,
      forceUpdate = TRUE
    )
  } else if (nrow(accounts) == 1) {
    rsconnect::deployApp(
      appDir = app_dir,
      server = accounts$server[1],
      account = accounts$name[1],
      forceUpdate = TRUE
    )
  } else {
    rsconnect::deployApp(
      appDir = app_dir,
      forceUpdate = TRUE
    )
  }
  message("Deployment completed successfully!")
}, error = function(e) {
  message("Deployment failed: ", e$message)
  quit(status = 1)
})
