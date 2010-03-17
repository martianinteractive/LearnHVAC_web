require 'spec_helper'

describe "scenarios/index.html.erb" do
  before(:each) do
    assign(:scenarios, [
      stub_model(Scenario,
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
      ),
      stub_model(Scenario,
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
      )
    ])
  end

  it "renders a list of scenarios" do
    render
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    response.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    response.should have_selector("tr>td", :content => false.to_s, :count => 2)
    response.should have_selector("tr>td", :content => false.to_s, :count => 2)
    response.should have_selector("tr>td", :content => false.to_s, :count => 2)
    response.should have_selector("tr>td", :content => false.to_s, :count => 2)
    response.should have_selector("tr>td", :content => false.to_s, :count => 2)
    response.should have_selector("tr>td", :content => false.to_s, :count => 2)
    response.should have_selector("tr>td", :content => false.to_s, :count => 2)
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    response.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
    response.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
  end
end
