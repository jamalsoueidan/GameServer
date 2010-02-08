# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_game_api_session',
  :secret      => '485f22a08ebc607a215f68ee4dbbecefe462c6d8eed77cd4a8d4045d5335b8392c099f473b24e3622918cf605db7c428a2ddb3504c978f655b2fbf58741c33fe'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
