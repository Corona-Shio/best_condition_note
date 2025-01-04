# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# あらゆるブラウザでTLS（Transport Layer Security）を使うように強制する
config.force_ssl = true