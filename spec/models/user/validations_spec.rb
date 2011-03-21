require 'spec_helper'

describe User, 'validations' do

  context "for a new user with valid attributes" do
    subject { Factory.build(:user) }

    it { should be_valid }

    it { should_not accept_values_for(:email, nil, '', '   ', 'bad format@example') }

    it { should accept_values_for(:email, 'a@b.com') }

    it { should_not accept_values_for(:name, nil, '', ' ') }

    it "requires email to be unique" do
      Factory(:user, :email => 'a@b.com')
      should_not accept_values_for(:email, 'a@b.com', 'A@b.com')
    end

    it { should_not accept_values_for(:password, nil, '', ' ', '123', '12345', '123456789012345678901') }
    ['123456', '12345678901234567890'].each do |pw|
      context "when the password confirmation is #{pw.inspect}" do
        before { subject.password_confirmation = pw }

        it { should accept_values_for(:password, pw) }
      end
    end

    context "when the password is valid" do
      it "requires confirmation" do
        subject.password_confirmation = subject.password.to_s + 'a'
        should_not accept_values_for(:password, subject.password)
      end
    end
  end

  context "for an existing user" do
    subject { u = Factory(:user); User.find(u.id) }

    it { should be_valid }

    it { should accept_values_for(:password, nil, '123456', '12345678901234567890') }

    it { should_not accept_values_for(:password, '', ' ', '123', '12345', '123456789012345678901') }

    context "when the password is present and valid" do
      before { subject.password = 'secret' }

      it "requires confirmation" do
        subject.password_confirmation = 'secreta'
        should_not accept_values_for(:password, 'secret')
      end
    end
  end

end