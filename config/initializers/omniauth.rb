Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, '5bhck1eg3l0i', 'c8IO2JxzHp74OvtQ'
  provider :facebook, '258896397535137', '9ec806195e7c2e95017663c3b8de83b5', :scope => 'user_photos, friends_photos, user_education_history, friends_education_history, user_work_history, friends_work_history, user_location, friends_location, user_about_me, friends_about_me, user_website, friends_website, read_stream, publish_stream, email'
  provider :twitter, 'ABP2ZruFX54U9FpM3HOzNg', '7sk9KK4mraEdpv9vvJfgeySnLsukauxOwQeK88WuhA'
  #provider :google_oauth2, '815307397724.apps.googleusercontent.com', 'MNhKJWej9dJaXv1AKhI9CD7E', {:access_type => 'online', :approval_prompt => ''}
  provider :google_oauth2, '815307397724.apps.googleusercontent.com', 'MNhKJWej9dJaXv1AKhI9CD7E', {
    :access_type => 'offline',
    :scope => 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar https://www.google.com/m8/feeds/',
    :redirect_uri => 'http://localhost:3000/auth/google_oauth2/callback'
  }
end