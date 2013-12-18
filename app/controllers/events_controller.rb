class EventsController < ApplicationController
	require 'date'
	require 'time'
	# before_action :set_event, only: [:show, :edit, :update, :destroy]
	before_action :correct_user,   only: :destroy

	# Event creation page
	def index
		@event = Event.new
	end

	# Event display page - shows users events and map
	def show
		@events = Event.where(:user_id => current_user['id'] )
		if @events.empty?
			redirect_to events_path, :notice => "Looks like you need to create some events first!"
		end
		@indStr = 'A'
		@hash = Gmaps4rails.build_markers(@events) do |event, marker|
			marker.lat event.latitude
			marker.lng event.longitude
			marker.infowindow  "<h5>" + event.event_name + "</h5>"
			marker.picture({"url" => "http://maps.google.com/mapfiles/kml/paddle/" + @indStr +"_maps.png",
				"width" =>  32, 
				"height" => 32 }) 
			marker.json({event_name: event.event_name, address: event.address})  
			@indStr = @indStr.succ      
		end    
	end

	#Public Event display page - shows events and map of a given user to the public
	def public
		@events = Event.where(:user_id => params[:event_id])		
		@indStr = 'A'
		@hash = Gmaps4rails.build_markers(@events) do |event, marker|
			marker.lat event.latitude
			marker.lng event.longitude
			marker.infowindow  "<h5>" + event.event_name + "</h5>"
			marker.picture({"url" => "http://maps.google.com/mapfiles/kml/paddle/" + @indStr +"_maps.png",
				"width" =>  32, 
				"height" => 32 }) 
			marker.json({event_name: event.event_name, address: event.address})  
			@indStr = @indStr.succ      
		end    

	end

	# Event creation page - stores individual events to database
	def create
		@event = Event.new(event_params)
		respond_to do |format|
			if @event.save
				format.html { redirect_to @event, notice: 'Event was successfully created.' }
				format.js
				format.json { render action: 'show', status: :created, location: @event }
			else
				format.html { render action: 'new' }
				format.json { render json: @event.errors, status: :unprocessable_entity }
			end
		end
	end

	# Destroys particular event based on the event ID
	# Checks for correct user using correct_user method
	def destroy
		@event.delete
		redirect_to event_path
	end

	# Sets the event id based on the user session and id parameter
	def correct_user
		@event = current_user.events.find_by(id: params[:id])
		redirect_to events_path if @event.nil?
	end

	def event_params
		params.require(:event).permit(:location, :event_date, :event_time, :event_details, :latitude, :longitude, :address, :user_id, :event_name)
	end
end
