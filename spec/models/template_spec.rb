require 'spec_helper'

describe Template do

  subject { Template.new }

  it { should_not accept_values_for(:name, nil, '', ' ') }

end