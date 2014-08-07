require 'spec_helper'

describe MyThreeFavorite::TwitterClient do

  describe "#new" do
    let(:method_name)   { 'user' }
    let(:profile_names) { ['sebasoga', ''] }

    it "removes empty strings from params" do
      twitter_client = MyThreeFavorite::TwitterClient.new(method_name, profile_names, false)
      expect(twitter_client.send(:params)).to eq ['sebasoga']
    end

    context "when params is nil" do
      it "assigns an empty array" do
        twitter_client = MyThreeFavorite::TwitterClient.new(method_name, [], false)
        expect(twitter_client.send(:params)).to eq []
      end
    end

    it "converts method_name to symbol" do
      twitter_client = MyThreeFavorite::TwitterClient.new(method_name, profile_names, false)
      expect(twitter_client.send(:method_name)).to eq :user
    end
  end

  describe ".get" do
    let(:method_name)   { :user }
    let(:profile_names) { ['sebasoga', 'wehostels'] }

    before do
      rails = double(:rails)
      stub_const("Rails", rails)
      allow(rails).to receive_message_chain(:logger, :info).with(anything)
    end

    it "creates an instance of TwitterClient class" do
      expect(MyThreeFavorite::TwitterClient).to receive(:new)
        .with(method_name, profile_names, false) { double.as_null_object }
      MyThreeFavorite::TwitterClient.get(method_name, profile_names, false)
    end

    it "sends 'get' message to a TwitterClient instance" do
      twitter_client_instance = double.as_null_object
      allow(MyThreeFavorite::TwitterClient).to receive(:new) { twitter_client_instance }
      expect(twitter_client_instance).to receive(:get)
      MyThreeFavorite::TwitterClient.get(method_name, profile_names)
    end

    it "sends 'method_name' message to Twitter class" do
      allow(Twitter).to receive(method_name).exactly(profile_names.count).times
      MyThreeFavorite::TwitterClient.get(method_name, profile_names)
    end

    context "when ordered is true" do
      let(:new_element) { double(created_at: Time.now) }
      let(:old_element) { double(created_at: Time.now - 1.day) }

      it "returns an array of elements ordered from the most recent to the most old one" do
        allow(Twitter).to receive(:user) { [old_element, new_element] }
        expect(
          MyThreeFavorite::TwitterClient.get(method_name, ['sebasoga'], true)
          ).to eq [new_element, old_element]
      end
    end

    context "when ordered is false" do
      let(:new_element) { double(created_at: Time.now) }
      let(:old_element) { double(created_at: Time.now - 1.day) }

      it "returns an array of elements in the same order they are returned by Twitter class" do
        allow(Twitter).to receive(:user) { [old_element, new_element] }
        expect(
          MyThreeFavorite::TwitterClient.get(method_name, ['sebasoga'], false)
          ).to eq [old_element, new_element]
      end
    end

    context "when Twitter:Error::TooManyRequests is raised" do
      it "assigns @tweets an empty array" do
        expect(Twitter).to receive(method_name) { raise Twitter::Error::TooManyRequests }
        expect(
          MyThreeFavorite::TwitterClient.get(method_name, profile_names)
          ).to eq []
      end
    end

    context "when Twitter:Error::NotFound is raised" do
      it "assigns @tweets an empty array" do
        allow(Twitter).to receive(method_name) { raise Twitter::Error::NotFound }
        expect(
          MyThreeFavorite::TwitterClient.get(method_name, profile_names)
          ).to eq []
      end
    end
  end
end
