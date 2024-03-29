require_relative 'test_helper'

class RedisInstegrationTest < MiniTest::Unit::TestCase
  attr_reader :redis

  def setup
    @redis = Redis.new
  end

  def test_operations_are_timed
    redis.set 'foo', 'bar'

    assert_timer 'redis.set'
  end
end
