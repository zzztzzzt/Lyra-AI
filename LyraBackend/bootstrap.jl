(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using LyraBackend
const UserApp = LyraBackend
LyraBackend.main()
