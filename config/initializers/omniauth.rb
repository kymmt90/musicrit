OmniAuth.configure do |config|
  config.logger = Rails.logger
  config.test_mode = true if Rails.env.test?
end
