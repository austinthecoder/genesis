require 'spec_helper'

describe Page, "normalizations" do

  [:title, :slug].each do |a|
    it { should normalize_attribute(a) }
  end

end