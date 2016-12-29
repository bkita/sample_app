require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: 'Example User', email: 'jb@test.com',
                     password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'name should not be longer than 50 chars' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'emsil should not be longer than 255 chars' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'should accept valid emails' do
    valid_emails = %w[test@email.com test+test@email.jp first.last@email.com FIRST_LAST-NAME@email.COM]

    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?
    end
  end

  test 'should not accept invalid emails' do
    invalid_emails = %w[name@email,com name_at_email.com name@email. name@emai_emai.com]

    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?
    end
  end

  test 'email should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'should allow mixed case email format' do
    mixed_case_email = 'Test@Test.Com'
    @user.email = mixed_case_email
    @user.save
    assert @user.valid?
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'should validate password min length of 6 chars' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'password should not be blank' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'authenticated? shoud return false for nil digest' do
    assert_not @user.authenticated?('')
  end
end
