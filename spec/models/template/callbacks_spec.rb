require 'spec_helper'

describe Template, 'callbacks' do

  context "after destroying" do
    subject { Factory(:template) }

    before do
      @fields = []
      2.times { @fields << Factory(:field) }
      2.times { @fields << Factory(:field, :template => subject) }
    end

    it "does not destroy any fields" do
      subject.destroy
      @fields.each do |f|
        lambda { f.reload }.should_not raise_error
      end
    end
  end

end