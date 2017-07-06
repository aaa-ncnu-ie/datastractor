require 'spec_helper'

describe Datastractor do
  it 'has a version number' do
    expect(Datastractor::VERSION).not_to be nil
  end

  describe Datastractor::Datastruct do
    let(:options) { {} }
    let(:datastruct) { Datastractor::Datastruct.new(options) }

    describe "#initialize" do
      specify { expect(datastruct.type).to be_nil }
      specify { expect(datastruct.init_client).to be_nil }
      specify { expect(datastruct.client).to be_nil }
      specify { expect(datastruct.access_token_name).to be_nil }
      specify { expect(datastruct.access_token).to be_nil }
    end

    describe "#verbose?" do
      context "when verbose flag is set to true" do
        let(:options) { {verbose: true} }

        specify { expect(datastruct.verbose?).to be true  }
      end

      context "when verbose flag is not set" do
        specify { expect(datastruct.verbose?).to be false }
      end

      context "when verbose flag is set to false" do
        let(:options) { {verbose: false} }

        specify { expect(datastruct.verbose?).to be false }
      end
    end
  end
end
