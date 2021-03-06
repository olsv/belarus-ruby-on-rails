class ProfilesController < ApplicationController
  include ApplicationHelper

  load_and_authorize_resource

  before_filter :get_profile

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @providers = @profile.providers_data

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update_attributes params[:profile]
        @profile.user.index!
        format.html { redirect_to get_stored_location, :notice => t('profile.profile_updated') }
      else
        format.html { render :action => :edit }
      end
    end
  end

  # DELETE /profiles/1/avatar
  def delete_avatar
    @profile.update_attributes(:avatar => nil)
    @profile.user.reload

    respond_to do |format|
      format.js { render :js => "change_avatar('#{ userpic_url(@profile.user, 98) }')" }
    end
  end

  private

  def get_profile
    @profile = Profile.includes(:user).find(params[:id])
  end
end
