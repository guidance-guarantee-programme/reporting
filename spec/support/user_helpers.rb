module UserHelpers
  def with_real_sso
    sso_env = ENV['GDS_SSO_MOCK_INVALID']
    ENV['GDS_SSO_MOCK_INVALID'] = '1'

    yield
  ensure
    ENV['GDS_SSO_MOCK_INVALID'] = sso_env
  end

  def given_a_user
    GDS::SSO.test_user = create(:user)
    yield
  ensure
    GDS::SSO.test_user = nil
  end
end
