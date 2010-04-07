class Students::ApplicationController < ApplicationController
  before_filter :require_student
  layout "students"
end