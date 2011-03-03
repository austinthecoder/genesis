require 'spec_helper'

describe Field do

  subject { Field.new }

  describe "#human_field_type" do
    {
      nil => nil,
      "short_text" => "short text",
      "long_text" => "long text"
    }.each do |field_type, human_field_type|
      context "when the field_type is #{field_type.inspect}" do
        before { subject.field_type = field_type }
        it { subject.human_field_type.should eq(human_field_type) }
      end
    end
  end

end