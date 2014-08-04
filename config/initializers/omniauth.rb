Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, 'IbzTMpXzx0mms0XV5LQdvoXDZ', 'pey7UDEjtdU39GeUG4OieFT3uAweql4JDMwkxRYrc8GUDm6rT5'
end