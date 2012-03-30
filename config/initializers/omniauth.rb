Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, '5bhck1eg3l0i', 'c8IO2JxzHp74OvtQ'
  #provider :facebook, 'APP_ID', 'APP_SECRET'
  #provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end
