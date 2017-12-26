require "test_helper"

class UserTest < Minitest::Test
  def test_uniq_filtering_based_on_login
    users = [
      User.new(login: "single"),
      User.new(login: "dupe"),
      User.new(login: "dupe")
    ]

    result = users.uniq

    assert_equal %w(single dupe), result.map(&:login)
  end
end
