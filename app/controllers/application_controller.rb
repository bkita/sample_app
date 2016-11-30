class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: 'hello from sample app'
  end
end
