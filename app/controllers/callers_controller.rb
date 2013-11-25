class CallersController < ApplicationController
  require "net/http"
  require "uri"

  def sign_in
    uri = URI.parse("http://localhost:3000/users/sign_in")
    query = {
      corp_id: params[:corp_id],
      otp: CGI::escape(params[:otp])
    }
    response = Net::HTTP.post_form(uri, query)
    if response.code != '200'
      @result = "{ result: 0, message: 'Could not connect to TFA server.' }"
    else
      @result = response.body
    end
  end
end
