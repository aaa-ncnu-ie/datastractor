require 'spec_helper'

describe Datastractor do
  describe Datastractor::Databox do
    let(:access_token) { "my-access-token" }
    let(:options) { {access_token: access_token} }
    let(:databox) { Datastractor::Databox.new(options) }

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
  end
end
