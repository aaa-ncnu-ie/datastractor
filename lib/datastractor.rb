require "datastractor/version"

module Datastractor
  class Datastruct
    attr_reader :type, :client, :access_token, :options

    def initialize(opts={})
      @access_token = opts[:access_token] || (access_token_name.nil? ? nil : ENV[access_token_name])
      @options   = {
        :verbose => false,
        :enabled => true
      }.merge(opts)

      init_client
    end

    def verbose?
      @options[:verbose] == true
    end

    # Subclass implementations

    def init_client
    end

    def access_token_name
    end

    # def enabled?
    #   options[:enabled]
    # end
  end
end
