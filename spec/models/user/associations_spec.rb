require 'spec_helper'

describe User, 'associations' do

  describe "pages" do
    subject { Factory(:user).pages }

    describe "#add!" do
      context "with valid attrs" do
        before { @attrs = {:title => 'title932', :template_id => '1'} }

        it "creates a page" do
          lambda { subject.add!(nil, @attrs) }.should change { Page.count }.by(1)
        end

        it "returns the page" do
          subject.add!(nil, @attrs).should be_a(Page)
        end

        describe "the created page" do
          let(:page) { Page.last }

          context "when a parent page is given" do
            before do
              @attrs[:slug] = 'slug29375'
              @parent_page = Factory(:page)
              subject.add!(@parent_page, @attrs)
            end
            it { page.parent.should == @parent_page }
            it { page.slug.should == 'slug29375' }
            it { page.title.should == 'title932' }
          end

          context "when parent page isn't given" do
            before { subject.add!(nil, @attrs) }
            it { page.parent.should == nil }
            it { page.title.should == 'title932' }
          end
        end

        it "creates contents for the page's fields" do
          page = Factory(:page)
          Page.stub(:new) { page }
          page.fields.should_receive(:create_contents!)
          subject.add!(nil, @attrs)
        end
      end

      context "with invalid attrs" do
        it "raises an error" do
          lambda { subject.add!(nil) }.should raise_error(ActiveRecord::RecordInvalid)
        end

        it "doesn't create any pages or contents" do
          lambda do
            subject.add!(nil) rescue nil
          end.should_not change { Page.count + Content.count }
        end
      end
    end

    describe "#update!" do
      before do
        @page = Factory(:page).reload
        @attrs = {:template_id => @page.template_id, :title => 'title95032'}
        @contents = (1..2).map { Factory(:content, :page => @page) }
      end

      it "updates the page" do
        @page.should_receive(:update_attributes!).with(@attrs)
        subject.update!(@page, @attrs)
      end

      it "returns the page" do
        subject.update!(@page, @attrs).should == @page
      end

      context "when the template changed" do
        before { @attrs[:template_id] = Factory(:template).id }

        it "destroys all of the page's current content" do
          subject.update!(@page, @attrs)
          @contents.each do |c|
            lambda { c.reload }.should raise_error(ActiveRecord::RecordNotFound)
          end
        end

        it "creates contents for the page's fields" do
          @page.fields.should_receive(:create_contents!)
          subject.update!(@page, @attrs)
        end
      end

      context "when the template didn't change" do
        it "doesn't destroy or create any content" do
          lambda { subject.update!(@page, @attrs) }.should_not change { Content.count }
        end
      end
    end
  end

end