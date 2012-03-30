Before('@omniauth') do
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:linkedin] = {
    "provider" => "linkedin",
    "uid" => "abc123"
  }
end

After ('@omniauth') do
  OmniAuth.config.test_mode = false
end
