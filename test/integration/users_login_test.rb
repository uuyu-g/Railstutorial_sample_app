require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid informaition" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "有効な情報でログインし、後にログアウト" do
    ##ログインの確認
    # ログイン用のパスを開く
    get login_path
    # セッション用パスに有効な情報をPOSTする
    post login_path, params:{session: {email: @user.email, password: 'password'}}
    assert is_logged_in?
    assert_redirected_to @user #リダイレクト先が正しいか
    follow_redirect! #実際にリダイレクト先に移動
    assert_template 'users/show'
    # ログイン用のリンクが表示されなくなったことを確認する
    assert_select "a[href=?]", login_path, count:0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    
    ## ログアウトのテスト
    # ログアウト用パスにDELETEする
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    # ログアウト用のリンクが表示されなくなったのを確認
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", user_path(@user),count:0
  end
end
