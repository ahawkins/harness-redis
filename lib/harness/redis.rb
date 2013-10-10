require "harness/redis/version"

require 'harness'
require 'redis'

module Harness
  class RedisGauge
    include Instrumentation

    attr_reader :redis

    def initialize(redis)
      @redis = redis
    end

    def log
      info = redis.info
      gauge 'redis.memory', info.fetch('used_memory').to_i
    end
  end
end

require 'active_support/core_ext/module'

# Taken from new relic redis
# https://github.com/evanphx/newrelic-redis/blob/master/lib/newrelic_redis/instrumentation.rb
class Redis
  class Client
    include Harness::Instrumentation

    def call_with_instrumentation(args, &block)
      method_name = args[0].is_a?(Array) ? args[0][0] : args[0]

      time "redis.#{method_name}" do
        call_without_instrumentation args, &block
      end
    end
    alias_method_chain :call, :instrumentation
  end
end
