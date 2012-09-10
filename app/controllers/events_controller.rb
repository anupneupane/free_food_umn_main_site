
class EventsController < ApplicationController
  # GET /events
  # GET /events.json

  before_filter :authenticate_admin!, :only => [:index, :update, :destroy, :edit]
  before_filter :authenticate_organization!, :only => [:create_event_from_session_stored_params]

  def admin_approve
    event_to_approve = Event.find(params[:id])
    event_to_approve.update_column(:approved_by_admin, true)
  end

  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    @event.meridian_indicator = "pm"
    @event.start_time_string = "10:00"
    @event.duration = "1:00"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create

    if params[:submit_as_organization]
      session[:stored_params] = params[:event]
      authenticate_organization!
      create_event_from_session_stored_params
      return
    end

    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to root_path, notice: 'Thank you for submitting the event! An admin should approve it shortly.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html {  }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_event_from_session_stored_params
    params = session[:stored_params]
    session[:stored_params] = nil
    params[:group_name] = current_organization.name
    @event = Event.new(params)
    if @event.save
      redirect_to root_path, notice: 'Thank you for submitting the event! An admin should approve it shortly.'
    else
      render action: "new"
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
