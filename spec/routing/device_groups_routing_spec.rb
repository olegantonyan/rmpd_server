require "rails_helper"

RSpec.describe DeviceGroupsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/device_groups").to route_to("device_groups#index")
    end

    it "routes to #new" do
      expect(:get => "/device_groups/new").to route_to("device_groups#new")
    end

    it "routes to #show" do
      expect(:get => "/device_groups/1").to route_to("device_groups#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/device_groups/1/edit").to route_to("device_groups#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/device_groups").to route_to("device_groups#create")
    end

    it "routes to #update" do
      expect(:put => "/device_groups/1").to route_to("device_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/device_groups/1").to route_to("device_groups#destroy", :id => "1")
    end

  end
end
