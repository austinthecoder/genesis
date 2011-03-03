require 'spec_helper'

describe Template, 'callbacks' do

  context "after destroying" do
    subject { Factory(:template) }

    it "destroys it's fields" do
      fields = (1..3).map { Factory(:field, :template => subject) }
      subject.destroy
      fields.each do |f|
        error = [ActiveRecord::RecordNotFound, "Couldn't find Field with ID=#{f.id}"]
        lambda { f.reload }.should raise_error(*error)
      end
    end

    it "does not destroy fields that do not belong to it" do
      fields = (1..2).map { Factory(:field) }
      subject.destroy
      fields.each do |f|
        lambda { f.reload }.should_not raise_error
      end
    end
  end

end