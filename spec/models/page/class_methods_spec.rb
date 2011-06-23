require 'spec_helper'

describe Page, "class methods" do
  describe ".find_by_request_path" do
    context "when a page exists with the request path" do
      it "returns it" do
        page = Factory(:sub_page, :parent => Factory(:sub_page, :slug => 'a'), :slug => 'b')
        Page.find_by_request_path('/a/b').should == page
      end
    end

    context "when a page does not exist with the request path" do
      it "returns nil" do
        Page.find_by_request_path('/a/b').should be_nil
      end
    end
  end
end