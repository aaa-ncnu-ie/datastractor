require 'spec_helper'

describe Datastractor do
  describe Datastractor::Databox do
    let(:access_token) { "my-access-token" }
    let(:options) { {access_token: access_token} }
    let(:databox) { Datastractor::Databox.new(options) }
    let(:databox_client) { double("databox-client") }

    before(:each) { allow(::Databox::Client).to receive(:new) { databox_client} }

    describe '#initialize' do
      context "when access_token is nil" do
        let(:options) { {} }

        it "should raise an exception" do
          expect {databox}.to raise_error(/Must specify access_token in params or in env/)
        end
      end

      context "when access_token is not nil" do
        specify { expect(databox.access_token).to eql(access_token) }
      end

      it "should default a submit_time option to a formatted time string" do
        expect(databox.options[:submit_time]).to match(/\d{4}-\d{02}-\d{02}\s\d{2}:\d{2}:\d{2}/)
      end
    end

    describe '#access_token_name' do
      specify { expect(databox.access_token_name).to eql("DATABOX_ACCESS_TOKEN") }
    end

    describe '#publish' do
      let(:metrics) { {:key1 => 10,:key2 => 20} }
      let(:attributes) { {:product => "My App Name"} }
      let(:publish_options) { {attributes: attributes} }

      before(:each) { expect(databox).to receive(:enabled?) { enabled? } }

      context "when enabled? is false" do
        let(:enabled?) { false }

        it "should not publish metrics" do
          expect(databox.client).not_to receive(:push)
          databox.publish(metrics, publish_options)
        end
      end

      context "when enabled? is true" do
        let(:enabled?) { true }

        it "should publish metrics" do
          expect(databox.client).to receive(:push).with(hash_including(key: "key1", value: 10, attributes: attributes))
          expect(databox.client).to receive(:push).with(hash_including(key: "key2", value: 20, attributes: attributes))
          databox.publish(metrics, publish_options)
        end
      end
    end
  end
end
