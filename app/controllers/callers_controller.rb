class CallersController < ApplicationController
  require "net/http"
  require "uri"

  def secondauth
    # URI for 2nd authen
    uri = URI.parse(Rails.application.config.tfa_server_uri+"/users/sign_in")
    # Get user ID from email
    begin
      user_id = User.where(email:params[:email]).first.id

      # Got user ID from email. Prepare query to 2nd auth
      query = {
        user_id: user_id,
        corp_id: Rails.application.config.corp_id,
        otp: CGI::escape(params[:otp])
      }
      response = Net::HTTP.post_form(uri, query)
      # puts response.body.as_json
      if response.code != "200"
        @result = { result: 0, message: 'Could not connect to 2nd factor authenticator.' }
      else
        @result = response.body.as_json
      end
    rescue
      @result = { result: 0, message: 'Invalid user email' }
    end

    respond_to do |format|
      format.html
      format.json { render json: @result }
    end
  end
end
