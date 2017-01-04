require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:bartek)
  end

  test 'invalid user details' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: { user: { name: '',
                                               email: 'em@ail',
                                               password: '123',
                                               password_confirmation: '321' } }
    assert_template 'users/edit'
  end

  test 'valid user details' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    name = 'Jo Black'
    email = 'jb@jbtest.com'

    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }

    assert_not flash.nil?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
