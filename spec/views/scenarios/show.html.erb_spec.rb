require 'spec_helper'

describe "scenarios/show.html.erb" do
  before(:each) do
    assign(:scenario, @scenario = stub_model(Scenario,
      :scenario_id => "MyString",
      :name => "MyString",
      :movie_url => "MyString",
      :thumbnail_url => "MyString",
      :level => 1,
      :inputs_visible => false,
      :inputs_enabled => false,
      :faults_visible => false,
      :faults_enabled => false,
      :allow_longterm_date_change => false,
      :allow_realtime_datetime_change => false,
      :valve_info_enabled => false,
      :short_description => "MyString",
      :description => "MyText",
      :goal => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    response.should contain("MyString")
    response.should contain("MyString")
    response.should contain("MyString")
    response.should contain("MyString")
    response.should contain(1)
    response.should contain(false)
    response.should contain(false)
    response.should contain(false)
    response.should contain(false)
    response.should contain(false)
    response.should contain(false)
    response.should contain(false)
    response.should contain("MyString")
    response.should contain("MyText")
    response.should contain("MyText")
  end
end
