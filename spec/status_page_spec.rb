require 'spec_helper'

describe Datastractor do
  describe Datastractor::StatusPage do
    let(:access_token) { "my-token" }
    let(:page_id) { "my-page-id" }
    let(:status_page) { Datastractor::StatusPage.new({access_token: access_token, page_id: page_id}) }

    let(:incident_components) {
      [
        {
          "status": "operational",
          "name": "My App A",
          "created_at": "2016-06-30T23:42:07.836Z",
          "updated_at": "2017-06-27T02:51:46.488Z",
        },
        {
          "status": "operational",
          "name": "My App B",
          "created_at": "2016-02-18T16:20:32.471Z",
          "updated_at": "2017-04-26T23:49:20.241Z",
        }
      ]
    }

    describe '#initialize' do
      context "access_token and page_id are passed in init options" do
        specify { expect(status_page.access_token).to eql(access_token) }
        specify { expect(status_page.page_id).to eql(page_id) }
        specify { expect(status_page.options).to eql({headers: {"Authorization" => "OAuth #{access_token}"}}) }
        specify { expect(status_page.type).to eql(:datasource) }
      end

      context "access_token and page_id are specified in environment variables" do
        let(:access_token) { nil }
        let(:page_id) { nil }
        let(:access_token_string) { "my-token" }
        let(:page_id_string) { "my-page-id" }
        before do
          expect(ENV).to receive(:[]).with('STATUS_PAGE_ACCESS_TOKEN') { access_token_string }
          expect(ENV).to receive(:[]).with('STATUS_PAGE_PAGE_ID') { page_id_string }
        end

        specify { expect(status_page.access_token).to eql(access_token_string) }
        specify { expect(status_page.page_id).to eql(page_id_string) }
        specify { expect(status_page.options).to eql({headers: {"Authorization" => "OAuth #{access_token_string}"}}) }
        specify { expect(status_page.type).to eql(:datasource) }
      end
    end

    describe '#access_token_name' do
      specify { expect(status_page.access_token_name).to eql("STATUS_PAGE_ACCESS_TOKEN") }
    end

    describe '#get_incidents' do
      let(:query) { "/v1/pages/#{status_page.page_id}/incidents.json" }
      let(:result_code) { 200 }
      let(:result_message) { "HTTParty message" }
      let(:result_body) { {body: "HTTParty body"}.to_json }
      let(:httparty_result) {
        double("HTTPartyResult",
          code: result_code,
          message: result_message,
          body: result_body
        )
      }
      let(:options) { {} }
      let(:parse_options) {
        {
          date_range: options[:date_range],
          status: options[:status]
        }
      }

      before(:each) do
        expect(Datastractor::StatusPage).to receive(:get).with(query, status_page.options) { httparty_result }
      end

      subject { status_page.get_incidents(options) }

      context "with empty options" do
        it "should query and parse for all incidents" do
          expect(Datastractor::StatusPage).to receive(:parse_incidents).with(JSON.parse(result_body), parse_options) { true }
          subject
        end
      end

      context "with search option specified" do
        let(:search) { "maintenance" }
        let(:options) { {search: search} }
        let(:query) { "/v1/pages/#{status_page.page_id}/incidents.json?q=#{search}" }

        it "should query with a search string and parse for incidents" do
          expect(Datastractor::StatusPage).to receive(:parse_incidents).with(JSON.parse(result_body), parse_options) { true }
          subject
        end
      end

      context "with date_range option specified" do
        let(:options) { {date_range: (Time.now.to_date - 1)..Time.now.to_date} }

        it "should query with for all incidents and parse with date_range" do
          expect(Datastractor::StatusPage).to receive(:parse_incidents).with(JSON.parse(result_body), parse_options) { true }
          subject
        end
      end

      context "with status option specified" do
        let(:options) { {status: "completed" } }

        it "should query with for all incidents and parse with status" do
          expect(Datastractor::StatusPage).to receive(:parse_incidents).with(JSON.parse(result_body), parse_options) { true }
          subject
        end
      end

      context "when get request throws a non 200" do
        let(:result_code) { 500 }

        it "should raise an exception" do
          expect {subject}.to raise_error("Received error #{result_code} #{result_message} #{result_body}")
        end
      end
    end

    describe 'self.parse_incidents' do
      let(:incidents_data) { 
        [
          {
            "name" => "Incident 1",
            "status" => "completed",
            "components" => incident_components,
            "created_at" => (DateTime.now - 3).to_s,
            "scheduled_for" => (DateTime.now - 2).to_s,
            "resolved_at" => (DateTime.now - 1).to_s
          },
          {
            "name" => "Incident 2",
            "status" => "scheduled",
            "components" => incident_components,
            "created_at" => (DateTime.now - 2).to_s,
            "scheduled_for" => (DateTime.now + 1).to_s,
            "resolved_at" => nil
          }
        ]
      }

      let(:date_range) { nil }
      let(:status) { nil }
      let(:options) {
        {
          date_range: date_range,
          status: status
        }
      }

      let(:parsed_incidents) { Datastractor::StatusPage.parse_incidents(incidents_data, options) }
      
      context "with no options passed" do
        it "should return an IncidentCollection" do
          expect(parsed_incidents.class).to eql(Datastractor::StatusPage::IncidentCollection)
          expect(parsed_incidents.incidents.size).to eql(incidents_data.size)
        end
      end

      context "with a status option passed" do
        let(:status) { "completed" }

        it "should return an array of incidents who has status of passed" do
          expect(parsed_incidents.incidents.all?{|incident| incident.status == status}).to be true
        end
      end

      context "with a date_range option passed" do
        let(:date_range) { (DateTime.now - 3)..(DateTime.now) }

        it "should return only incidents for which the scheduled_for time is in passed date range" do
          expect(parsed_incidents.incidents.all?{|incident| date_range.cover? incident.scheduled_for}).to be true
        end
      end
    end

    describe Datastractor::StatusPage::Incident do
      let(:incident_name) { "Test Incident Name" }
      let(:incident_status) { "completed" }
      let(:impact) { "scheduled" }
      let(:incident_scheduled_for) { DateTime.now }
      let(:incident_created_at) { DateTime.now - 1 }
      let(:incident_resolved_at) { DateTime.now + 2 }

      let(:incident_data) { FactoryGirl.build(:incident_data, {
          "name" => incident_name,
          "status" => incident_status,
          "impact" => impact,
          "components" => incident_components,
          "created_at" => incident_created_at.to_s,
          "scheduled_for" => (incident_scheduled_for.nil? ? nil : incident_scheduled_for.to_s),
          "resolved_at" => incident_resolved_at.to_s
        })
      }

      let(:incident) { Datastractor::StatusPage::Incident.new(incident_data) }

      describe '#initialize' do
        it "should initialize used incident data" do
          expect(incident.name).to eql(incident_name)
          expect(incident.status).to eql(incident_status)
          expect(incident.impact).to eql(impact)
          expect(incident.affected_components).to eql(incident_components.collect {|component| component["name"] })
          expect(incident.created_at.to_s).to eql(incident_created_at.to_s)
        end

        context "when scheduled_for is specified" do
          it "should have scheduled_for date object" do
            expect(incident.scheduled_for.to_s).to eql(incident_scheduled_for.to_s)
          end
        end

        context "when scheduled_for is not specified" do
          let(:incident_data) { FactoryGirl.build(:incident_data, {"scheduled_for" => nil}) }
          
          it "should have nil for scheduled_for " do
            expect(incident.scheduled_for).to be_nil
          end
        end
      end

      describe '#duration' do
        context "when incident is maintenance" do
          it "should return seconds between resolved_at and scheduled_for" do
            expect(incident.duration).to eql((incident_resolved_at.to_time - incident_scheduled_for.to_time).round)
          end
        end

        context "when incident is not maintenance" do
          let(:incident_scheduled_for) { nil }

          it "should return seconds between resolved_at and created_at" do
            expect(incident.duration).to eql((incident_resolved_at.to_time - incident_created_at.to_time).round)
          end
        end
      end

      describe '#duration_in_minutes' do
        it "should return the duration in minutes rounded to nearest whole" do
          expect(incident).to receive(:duration) { 175 }
          expect(incident.duration_in_minutes).to eql(3)
        end
      end

      describe '#is_date_in_range' do
        let(:range) { (DateTime.now - 2)..(DateTime.now + 1) }

        context "when scheduled_for is today" do
          it "should be in range" do
            expect(incident.is_in_date_range(range)).to be true
          end
        end

        context "when scheduled_for is 2 days from now" do
          let(:incident_scheduled_for) { DateTime.now + 2 }

          it "should not be in range" do
            expect(incident.is_in_date_range(range)).to be false
          end
        end

        context "when scheduled_for is nil" do
          let(:incident_scheduled_for) { nil }

          context "and created_at is today" do
            let(:incident_created_at) { DateTime.now }

            it "should be in range" do
              expect(incident.is_in_date_range(range)).to be true
            end
          end
        end
      end
    end

    describe Datastractor::StatusPage::IncidentCollection do
      let(:incident_1) { FactoryGirl.build(:incident, "name" => 'Incident 1') }
      let(:incident_2) { FactoryGirl.build(:incident, "name" => 'Incident 2') }
      let(:incidents) { [incident_1, incident_2] }
      let(:incident_collection) { Datastractor::StatusPage::IncidentCollection.new(incidents) }

      describe '#initialize' do
        specify { expect(incident_collection.incidents).to eql(incidents) }
      end

      describe '#duration' do
        it "should return cumulative incident duration for the collection" do
          expect(incident_collection.duration).to eql(incident_1.duration + incident_2.duration)
        end
      end
    end
  end
end
