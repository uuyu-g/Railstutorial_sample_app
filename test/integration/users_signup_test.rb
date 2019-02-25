require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "inviled signup information" do 
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmations: "bar"
        }}
    end
    assert_template 'users/new'
  end
end
