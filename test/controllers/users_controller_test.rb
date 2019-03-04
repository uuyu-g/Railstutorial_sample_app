require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "ログインしていない時、indexからログインページにリダイレクト" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "他のユーザーで ログインしている時、editにリダイレクトする" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "他のユーザーでログインしている時、updateにリダイレクトする" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  # test "adimin属性をWeb経由で編集することを許可しない" do
  #   log_in_as(@other_user)
  #   assert_not @other_user.admin?
  #   patch user_path(@other_user), params: {
  #                                   user: { password:              "password",
  #                                           password_confirmation: "password",
  #                                           admin: 1 } }
  #   assert_not @other_user.FILL_IN.admin?
  # end

  test "ログインしていない時、destroyからログイン画面にリダイレクト" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "ログイン済みでも管理者でなければ、destroyからホーム画面にリダイレクト" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end
