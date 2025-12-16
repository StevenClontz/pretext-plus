class PagesController < ApplicationController
  allow_unauthenticated_access
  def home
    render layout: false
  end
end
