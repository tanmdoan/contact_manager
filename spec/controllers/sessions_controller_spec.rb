require 'rails_helper'

describe SessionsController do

  before(:each) do
    Rails.application.routes.draw do
      resource :sessions, :only => [:create, :destroy]
      root to: 'site#index'
    end
  end

  after(:each) do
    Rails.application.reload_routes!
  end

  describe '#create' do


    it "logs in a new user" do
      @request.env["omniauth.auth"] = {
        'provider' => 'twitter',
        'info' => {'name' => 'Alice Smith'},
        'uid' => 'abc123'
      }

      post :create
      user = User.find_or_create_by(uid: 'abc123', provider: 'twitter')
      expect(controller.current_user.id).to eq(user.id)
    end

    it "logs in an existing user" do
      @request.env["omniauth.auth"] = {
        'provider' => 'twitter',
        'info' => {'name' => 'Bob Jones'},
        'uid' => 'xyz456'
      }

      user = User.find_or_create_by(provider: 'twitter', uid: 'xyz456', name: 'Bob Jones')

      post :create
      expect(User.count).to eq(1)
      expect(controller.current_user.id).to eq(user.id)
    end

    it 'redirects to the companies page' do
      @request.env["omniauth.auth"] = {
        'provider' => 'twitter',
        'info' => {'name' => 'Charlie Allen'},
        'uid' => 'prq987'
      }
      user = User.create(provider: 'twitter', uid: 'prq987', name: 'Charlie Allen')
      post :create
      expect(response).to redirect_to(root_path)
    end

    it 'user is able to logout' do
      @request.env["omniauth.auth"] = {
        'provider' => 'twitter',
        'info' => {'name' => 'Charlie Allen'},
        'uid' => 'prq987'
      }
      user = User.create(provider: 'twitter', uid: 'prq987', name: 'Charlie Allen')
      post :create

      post :destroy

      expect(controller.current_user).to eq(nil)
    end

    it 'user is redirected to root path after logout' do
      post :destroy
      expect(response).to redirect_to(root_path)
    end

  end

end
