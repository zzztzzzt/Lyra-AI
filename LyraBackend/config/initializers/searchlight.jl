using SearchLight, SearchLightPostgreSQL

try
  SearchLight.Configuration.load(ENV["SEARCHLIGHT_DB_CONFIG"])
  SearchLight.connect()
  @info "[SearchLight] Connected to PostgreSQL successfully."
catch e
  @warn "[SearchLight] Failed to connect to PostgreSQL on startup." exception=(e, catch_backtrace())
end
