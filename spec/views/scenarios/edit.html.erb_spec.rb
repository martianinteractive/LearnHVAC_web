require 'spec_helper'

describe "scenarios/edit.html.erb" do
  before(:each) do
    assign(:scenario, @scenario = stub_model(Scenario,
      :new_record? => false,
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

  it "renders the edit scenario form" do
    render

    response.should have_selector("form", :action => scenario_path(@scenario), :method => "post") do |form|
      form.should have_selector("input#scenario_scenario_id", :name => "scenario[scenario_id]")
      form.should have_selector("input#scenario_name", :name => "scenario[name]")
      form.should have_selector("input#scenario_movie_url", :name => "scenario[movie_url]")
      form.should have_selector("input#scenario_thumbnail_url", :name => "scenario[thumbnail_url]")
      form.should have_selector("input#scenario_level", :name => "scenario[level]")
      form.should have_selector("input#scenario_inputs_visible", :name => "scenario[inputs_visible]")
      form.should have_selector("input#scenario_inputs_enabled", :name => "scenario[inputs_enabled]")
      form.should have_selector("input#scenario_faults_visible", :name => "scenario[faults_visible]")
      form.should have_selector("input#scenario_faults_enabled", :name => "scenario[faults_enabled]")
      form.should have_selector("input#scenario_allow_longterm_date_change", :name => "scenario[allow_longterm_date_change]")
      form.should have_selector("input#scenario_allow_realtime_datetime_change", :name => "scenario[allow_realtime_datetime_change]")
      form.should have_selector("input#scenario_valve_info_enabled", :name => "scenario[valve_info_enabled]")
      form.should have_selector("input#scenario_short_description", :name => "scenario[short_description]")
      form.should have_selector("textarea#scenario_description", :name => "scenario[description]")
      form.should have_selector("textarea#scenario_goal", :name => "scenario[goal]")
    end
  end
end
