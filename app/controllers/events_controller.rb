
class EventsController < ApplicationController

  before_filter :authenticate_admin!, :only => [:index, :update, :destroy, :edit]
  before_filter :authenticate_organization!, :only => [:create_event_from_session_stored_params]

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

    if @event.save
      redirect_to root_path, notice: 'Thank you for submitting the event! An admin should approve it shortly.'
    else
      redirect_to new_event_path, alert: "#{@event.errors.full_messages.join(', ')}"
    end
  end

  def create_event_from_session_stored_params
    params = session[:stored_params]
    session[:stored_params] = nil
    organization = Organization.where(email: current_organization.email).first
    if organization.events.create(params)
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
      format.html { redirect_to '/admin' }
      format.json { head :no_content }
    end
  end
end
