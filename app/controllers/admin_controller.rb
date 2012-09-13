
class AdminController < ApplicationController

  before_filter :authenticate_admin!, :only => [:index, :update, :destroy, :edit]

  def index
    @events = Event.order("created_at DESC").all
    @organizations = Organization.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def admin_approve_event
    to_approve = Event.find(params[:id])
    to_approve.update_column(:approved_by_admin, true)
    return render :text => "success!"
  end

  def admin_approve_organization
    to_approve = Organization.find(params[:id])
    to_approve.update_column(:approved_by_admin, true)
    return render :text => "success!"
  end

end