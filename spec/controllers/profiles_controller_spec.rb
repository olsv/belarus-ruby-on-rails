require 'spec_helper'

describe ProfilesController do
  include SessionsHelper

  before(:each) do
    sign_in sign_in_user
  end

  context "when logged in as admin" do
    let(:sign_in_user) { FactoryGirl.create(:user, :is_admin => true) }

    describe "#edit" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        get :edit, :id => @user.profile.id
      end

      it "assigns the requested profile as @profile" do
        assigns(:profile).should eq(@user.profile)
      end

      it "renders the 'edit' template" do
        response.should render_template(:edit)
      end
    end

    describe "#update" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        store_location profile_path(@user.profile)
        put :update, :id => @user.profile.id, :profile => attributes
      end

      context "with valid params" do
        let(:attributes) { { :first_name => @first_name = "test" } }

        it "updates the requested profile" do
          @user.profile.reload
          @user.profile.first_name.should eq(@first_name)
        end

        it "assigns the requested profile as @profile" do
          assigns(:profile).should eq(@user.profile)
        end

        it "redirects to the profile" do
          response.should redirect_to(@user.profile)
        end
      end

      context "with invalid params" do
        let(:attributes) { { :first_name => "" } }

        it "assigns the profile as @profile" do
          assigns(:profile).should eq(@user.profile)
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end
    end
  end

  context "when logged in as user" do
    let(:sign_in_user) { FactoryGirl.create(:user) }

    describe "#show" do
      before(:each) do
        @user = sign_in_user
        get :show, :id => @user.profile.id
      end

      it "assigns the requested profile as @profile" do
        assigns(:profile).should eq(@user.profile)
      end

      it "renders the 'show' template" do
        response.should render_template(:show)
      end
    end

    describe "#edit" do
      context "when profile belongs to user" do
        before(:each) do
          @user = sign_in_user
          get :edit, :id => @user.profile.id
        end

        it "assigns the requested profile as @profile" do
          assigns(:profile).should eq(@user.profile)
        end

        it "renders the 'edit' template" do
          response.should render_template(:edit)
        end
      end

      context "when profile belongs to another user" do
        it "is forbidden" do
          user = FactoryGirl.create(:user)
          get :edit, :id => user.profile.id

          response.status.should eq(403)
        end
      end
    end

    describe "#update" do
      before(:each) do
        @user = sign_in_user
        store_location profile_path(@user.profile)
        put :update, :id => @user.profile.id, :profile => attributes
      end

      context "with valid params" do
        let(:attributes) { { :first_name => @first_name = "test",
                             :avatar => Rack::Test::UploadedFile.new("spec/fixtures/files/upic_default.jpg", 'image/jpg') } }

        it "updates the requested profile" do
          @user.profile.reload
          @user.profile.first_name.should eq(@first_name)
          @user.profile.avatar.exists?.should be_true
        end

        it "assigns the requested profile as @profile" do
          assigns(:profile).should eq(@user.profile)
        end

        it "redirects to the profile" do
          response.should redirect_to(@user.profile)
        end
      end

      context "with invalid params" do
        let(:attributes) { { :first_name => "" } }

        it "assigns the profile as @profile" do
          assigns(:profile).should eq(@user.profile)
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end
    end

    describe "#avatar" do
      before(:each) do
        @user = FactoryGirl.create(:user, :profile => FactoryGirl.create(:profile_with_upic))
        sign_in @user
      end

      context 'on own profile' do
        before(:each) do
          xhr :delete, :delete_avatar, :id => @user.profile.id
        end

        it 'delete avatar' do
          @user.profile.avatar.exists?.should be_false
        end
      end

      context 'on foreigner profile' do
        before(:each) do
          @another_user = FactoryGirl.create(:user, :profile => FactoryGirl.create(:profile_with_upic))
          xhr :delete, :delete_avatar, :id => @another_user.profile.id
        end

        it "don't delete avatar" do
          @another_user.profile.avatar.exists?.should be_true
        end
      end
    end
  end

  context "when not logged in" do
    let(:sign_in_user) { User.new }

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "#show" do
      it "redirects to login path" do
        get :show, :id => @user.profile.id
        response.should redirect_to(login_path)
      end
    end

    describe "#edit" do
      it "redirects to login path" do
        get :edit, :id => @user.profile.id
        response.should redirect_to(login_path)
      end
    end

    describe "#update" do
      it "redirects to login path" do
        post :update, :id => @user.profile.id
        response.should redirect_to(login_path)
      end
    end
  end

  context "nested #update" do
    let(:sign_in_user) { FactoryGirl.create(:user, :is_admin => true) }

    before(:each) do
      @user = FactoryGirl.create(:user)
      store_location profile_path(@user.profile)
      put :update, :id => @user.profile.id, :profile => user_attributes
    end

    describe 'with nested params' do
      let(:user_attributes) do
        {
          "user_attributes" => { "email" => "test@mail.com" }
        }
      end

      it 'should succeed' do
        response.status.should be(200)
      end
    end
  end
end
