Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, '5bhck1eg3l0i', 'c8IO2JxzHp74OvtQ'
  provider :facebook, '258896397535137', '9ec806195e7c2e95017663c3b8de83b5', :scope => 'read_stream, publish_stream'
  provider :twitter, 'ABP2ZruFX54U9FpM3HOzNg', '7sk9KK4mraEdpv9vvJfgeySnLsukauxOwQeK88WuhA'
end