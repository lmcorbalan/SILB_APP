class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :admin_user

end