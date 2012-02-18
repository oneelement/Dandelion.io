require "spec_helper"

describe Product do

  context "when there are versions of the product" do

    let(:product) do
      Fabricate(:product_with_versions)
    end

    it "fetches live versions" do
      product.live_versions.first.version_description.should == 'live'
    end

    it "fetches dev versions" do
      product.development_versions.first.version_description.should == 'development'
    end

  end

end
