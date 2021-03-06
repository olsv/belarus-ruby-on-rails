require 'spec_helper'

describe ApplicationHelper do
  let(:user) { FactoryGirl.build_stubbed(:user, :profile => FactoryGirl.build(:profile)) }

  describe '#errors_for' do
    before(:each) do
      @custom_message = 'Custom Message'
    end

    describe "called for model without errors" do
      it "should be empty" do
        user.should be_valid
        errors_for(user).should be_empty
      end
    end

    describe "called for model with errors" do
      before(:each) do
        user.email = ''
        user.password = ''
        user.password_confirmation = ''
        user.should_not be_valid
      end

      it "should contain right formatted HTML String with error information" do
        errors_for(user).should include "div id='error_explanation'"
        errors_for(user).should include "<h2>3 error"
      end

      it "with custom message should contain custom message" do
        errors_for(user, @custom_message).should include @custom_message
      end
    end
  end

  describe '#userpic_url' do
    context 'for user with avatar' do
      let(:user) { FactoryGirl.create(:user, :profile => FactoryGirl.create(:profile_with_upic)) }

      it 'should contain path to local avatar' do
        userpic_url(user, 50).should include user.profile.avatar.url :thumb
      end
    end

    context 'for user without avatar' do
      it 'should contain link to Gravatar icon' do
        userpic_url(user, 50).should include 'http://gravatar.com'
      end
    end
  end
end
