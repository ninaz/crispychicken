class ContactFormsController < ApplicationController
skip_before_filter :require_signin
    def new
      @contact_form = ContactForm.new
    end

    def thank_you
      begin
        @contact_form = ContactForm.new(params[:contact_form])
        @contact_form.request = request
        if @contact_form.valid?
          @contact_form.deliver
          render :thank_you
        else
          render :new
        end
      rescue ScriptError
        flash[:error] = 'Sorry, this message appears to be spam and was not delivered.'
      end
    end
  end