# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_learnhvac_session',
  :secret => '986402a7b36ddca704c5c575f170878cd5c78826e69665c8dde89cff59fdaf659e15f926b1cb3cce032f224287b25ad23b939fe7bef00b039a83d2818f83a911'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
