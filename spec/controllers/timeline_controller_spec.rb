require 'spec_helper'

describe TimelineController, type: :controller do

  describe "GET #index" do
    it "renders the 'timeline/index' view" do
      get :index
      expect(response).to render_template :index
    end

    it "responds successfully" do
      get :index
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    it "sends 'get' message to MyThreeFavorite::TwitterClient class" do
      expect(MyThreeFavorite::TwitterClient).to receive(:get).exactly(2).times
      post :create, profile_names: ['name']
    end

    it "renders the 'timeline/show' view" do
      post :create, {}
      expect(response).to render_template :show
    end

    context "instance variables" do
      let(:response) { double.as_null_object }
      before { allow(MyThreeFavorite::TwitterClient).to receive(:get) { response } }

      it "assigns @users an empty array" do
        put :create, {}
        expect(assigns[:users]).to eq response
      end

      it "assigns @tweets Twitter client's response" do
        put :create, {}
        expect(assigns[:tweets]).to eq response
      end
    end
  end

  describe "PUT #update" do
    it "sends 'update' message to Timeline class" do
      expect(
        MyThreeFavorite::TwitterClient
      ).to receive(:get).with(:user_timeline, ['name'], true)
      put :update, profile_names: ['name']
    end

    it "renders 'timeline' partial" do
      expect(MyThreeFavorite::TwitterClient).to receive(:get)
      post :update, {}
      expect(response).to render_template 'timeline/_timeline'
    end

    context "instance variable" do
      let(:tweet) { double.as_null_object }

      it "assigns @tweets Twitter client's response" do
      expect(MyThreeFavorite::TwitterClient).to receive(:get) { [tweet] }
        put :update, {}
        expect(assigns[:tweets]).to eq [tweet]
      end
    end
  end
end
