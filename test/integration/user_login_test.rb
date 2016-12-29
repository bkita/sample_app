require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:bartek)
  end

  test 'user login with invalid email/password' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'user login with valid email/password followed by logout' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert is_logged_in?
    assert redirect_to: @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)

    delete logout_path
    assert_not is_logged_in?
    assert redirect_to: root_url

    # Simulate user logs out on the 2nd tab
    delete logout_path

    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'login with selected remember me' do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token'].nil?
  end

  test 'login without selected remember me' do
    log_in_as(@user, remember_me: '0')
    assert cookies['remember_token'].nil?
  end
end
