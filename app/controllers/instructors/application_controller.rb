class Instructors::ApplicationController < ApplicationController
  before_filter :require_instructor
  layout "instructors"
end