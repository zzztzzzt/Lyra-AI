using Genie

Genie.config.cors_allowed_origins = [
    "http://localhost:5173",
    "http://localhost:5174",
    "http://localhost:3000"
    #,"https://your-production-domain.com"
]

Genie.config.cors_headers = Dict(
    "Access-Control-Allow-Methods" => "GET, POST, PUT, DELETE, OPTIONS",
    "Access-Control-Allow-Headers" => "Content-Type, Authorization, X-Requested-With",
    "Access-Control-Allow-Credentials" => "true",

    # Cache CORS preflight response for 24 hours to reduce network latency
    "Access-Control-Max-Age"  => "86400"
)