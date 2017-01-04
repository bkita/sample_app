require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test 'invalid user details' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                        email: 'em@ail',
                                        password: '123',
                                        password_confirmation: '321' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid user details' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Jo Black',
                                         email: 'jb@test.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.nil?
  end
end
