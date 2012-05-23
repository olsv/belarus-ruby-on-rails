class Admin::UsersController < ApplicationController
  load_and_authorize_resource :class => User

  def index
    store_location

    respond_to do |format|
      format.html { @users = User.filter(params[:filters])
        .paginate(:per_page => 10, :page => params[:page], :order => 'users.created_at DESC') }
      format.csv { export_csv(params[:filters]) }
    end
  end

  def update
    user = User.find(params[:id])
    case params[:attr]
      when 'admin'
        user.change_admin_state!
      when 'banned'
        user.change_banned_state!
    end

    redirect_to :action => :index
  end

  protected

  def export_csv(filters)
    require 'iconv'
    filename = I18n.l(Time.now, :format => :short) + "- Users.csv"
    content = Iconv.conv("UTF-16", "UTF-8", User.to_csv(User.filter(filters)))
    send_data content, :filename => filename
  end
end