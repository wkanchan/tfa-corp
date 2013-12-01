class CallersController < ApplicationController
  require "net/http"
  require "uri"

  def secondauth
    # Do the sign in
    uri = URI.parse(Rails.application.config.tfa_server_uri+"/users/sign_in")
    query = {
      corp_id: Rails.application.config.corp_id,
      otp: CGI::escape(params[:otp])
    }
    response = Net::HTTP.post_form(uri, query)
    puts response.body.as_json
    if response.code != "200"
      @result.result = 0
      @result.message = 'Could not connect to 2nd factor authenticator.'
    else
      @result = response.body.as_json
    end

    respond_to do |format|
      format.html
      format.json { render json: @result }
    end
  end
end
