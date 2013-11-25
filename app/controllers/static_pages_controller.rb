class StaticPagesController < ApplicationController
  def home
  end

  def help
    if params[:key]
      @result = AES.encrypt(params[:user_id]+","+params[:nonce]+","+params[:passcode],params[:key]).gsub "\n","\\n"
    else
      @result = ""
    end
  end
end
