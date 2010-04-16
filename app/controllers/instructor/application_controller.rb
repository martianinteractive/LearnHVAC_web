class Instructor::ApplicationController < ApplicationController
  before_filter :require_instructor
  layout "instructor"
end