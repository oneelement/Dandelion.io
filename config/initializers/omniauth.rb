Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, '5bhck1eg3l0i', 'c8IO2JxzHp74OvtQ'
  provider :facebook, '258896397535137', '9ec806195e7c2e95017663c3b8de83b5'
  #provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end
