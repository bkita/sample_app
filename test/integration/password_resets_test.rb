require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:bartek)
  end

  test 'should render password reset new template' do
    get new_password_reset_path
    assert_template 'password_resets/new'
  end

  test 'submit empty email shows flash error' do
    get new_password_reset_path
    post password_resets_path password_reset: { email: ' '}
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end

  test 'submit not existing email shows flash error' do
    get new_password_reset_path
    post password_resets_path password_reset: { email: 'joblack123321@jbtest321123.com'}
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end

  test 'submit vaild email redirects to root url' do
    get new_password_reset_path
    post password_resets_path password_reset: { email: @user.email}
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'submit vaild email sends email' do
    get new_password_reset_path
    post password_resets_path password_reset: { email: @user.email}
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test 'submit vaild email create reset digest in the db' do
    get new_password_reset_path
    post password_resets_path password_reset: { email: @user.email}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    @user_obj = assigns(:user)
  end

  test 'password reset form validation' do
    get new_password_reset_path
    post password_resets_path password_reset: { email: @user.email}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    user = assigns(:user)

    # Empty email in link
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url

    # Invalid token in link
    get edit_password_reset_path('invalid_token', email: user.email)
    assert_redirected_to root_url

    # Inactive user with valid token and email
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url

    # Valid tonek and email
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: 'foobaaz',
                  password_confirmation: 'boofar' }

    assert_select 'div#error_explanation'
    assert_template 'password_resets/edit'

    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: ' ',
                  password_confirmation: ' ' }

    assert_select 'div#error_explanation'
    assert_template 'password_resets/edit'

    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: 'foobar',
                  password_confirmation: 'foobar' }

    assert_not flash.empty?
    assert is_logged_in?
    assert_redirected_to @user
  end
end
