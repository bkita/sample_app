require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:bartek)
    @micropost = @user.microposts.build(content: 'Lorem Ipsum')
  end

  test 'micropost should be valid' do
    assert @micropost.valid?
  end

  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content should be present' do
    @micropost.content = ' '
    assert_not @micropost.valid?
  end

  test 'content max length 140 chars' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test 'order most_recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
