class CallersController < ApplicationController
  require "net/http"
  require "uri"

  def sign_in_1
    # Check parameters
    if params[:user_id].nil? or params[:password].nil?
      @result = "{ result: 0, message: 'Require user_id and otp parameters' }"
      return
    end

    if params[:user_id] == '1' and params[:password] == '12345678'
      @result = "{ result: 1, message: '1st authen successful. Send me OTP now.' }"
      return
    else
      @result = "{ result: 0, message: 'Wrong user_id or password' }"
    end
  end

  def sign_in_2
    # Do the sign in
    uri = URI.parse(Rails.application.config.tfa_server_uri+"/users/sign_in")
    query = {
      corp_id: Rails.application.config.corp_id,
      otp: CGI::escape(params[:otp])
    }
    response = Net::HTTP.post_form(uri, query)
    if response.code != "200"
      @result['result'] = 0
      @result['message'] = 'Could not connect to 2nd factor authenticator.'
    else
      @result = response.body.to_json
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @result }
    end
  end
end
