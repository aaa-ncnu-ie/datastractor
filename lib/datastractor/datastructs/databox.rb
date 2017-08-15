require 'datastractor'
require 'databox'

module Datastractor
  class Databox < Datastruct
    def initialize(opts={})
      super
      @options.merge!(
        submit_time: Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
      ).merge!(opts)

      raise("Must specify access_token in params or in env\n
        Env var:\n\t
          #{access_token_name}") if(enabled? && @access_token.nil?)
    end

    def init_client
      puts "access_token: #{self.access_token}" if verbose?
      ::Databox.configure do |c| 
        c.push_token = self.access_token
      end

      @client = ::Databox::Client.new
    end

    def access_token_name
      "DATABOX_ACCESS_TOKEN"
    end

    def publish(metrics, opts={})
      if enabled?
        metrics.each_pair { |metric, value| puts "client.push(key: #{metric.to_s}, value: #{value}, date: #{@options[:submit_time]}, attributes: #{opts[:attributes]})" } if verbose?
        metrics.each_pair { |metric, value| client.push(key: metric.to_s, value: value, date: options[:submit_time], attributes: opts[:attributes]) }
      end
    end
  end
end
