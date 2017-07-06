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
    end

    describe '#access_token_name' do
      specify { expect(databox.access_token_name).to eql("DATABOX_ACCESS_TOKEN") }
    end
  end
end
