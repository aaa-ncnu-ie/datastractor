require 'httparty'
require 'date'

module Datastractor
  class StatusPage
    include HTTParty

    base_uri 'api.statuspage.io'
    #debug_output $stdout

    ACCESS_TOKEN = ENV['STATUS_PAGE_ACCESS_TOKEN']
    PAGE_ID      = ENV['STATUS_PAGE_PAGE_ID']

    def initialize
      @options = { headers: {"Authorization" => "OAuth #{ACCESS_TOKEN}"} }
    end

    def get_incidents(options={})
      opts = {
        search:     nil,
        date_range: nil,
        status:     nil
      }.merge(options)

      query = "/v1/pages/#{PAGE_ID}/incidents.json"
      query += "?q=#{opts[:search]}" unless opts[:search].nil?

      res = self.class.get(query, @options)

      raise "Received error #{res.code} #{res.message} #{res.body}" unless res.code == 200
      Incident.parse_incidents JSON.parse(res.body), {date_range: opts[:date_range], status: opts[:status]}
    end

    def self.parse_incidents(incidents_data, options={})
      opts = {
        date_range: nil,
        status: nil
      }.merge(options)

      incidents_data.collect { |incident_data| Incident.new(incident_data) }
        .reject { |incident| !opts[:date_range].nil? && !incident.is_in_date_range(opts[:date_range]) }
        .reject { |incident| !opts[:status].nil? && incident.status != opts[:status] }
    end

    class Incident < StatusPage

      attr_reader :name, :status, :affected_components, :scheduled_for, :resolved_at
      
      def initialize(incident_data)
        @name   = incident_data["name"]
        @status = incident_data["status"]
        @affected_components = incident_data["components"].collect {|component| component["name"] }
        @scheduled_for = incident_data["scheduled_for"].nil? ? nil : DateTime.parse(incident_data["scheduled_for"])
        @resolved_at   = incident_data["resolved_at"].nil? ? nil : DateTime.parse(incident_data["resolved_at"])
      end

      def duration
        @resolved_at.to_time - @scheduled_for.to_time
      end

      def duration_in_minutes
        (duration/60).round
      end

      def is_in_date_range(range)
        range.cover? @scheduled_for
      end
    end
  end
end
