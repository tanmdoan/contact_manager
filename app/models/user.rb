class User < ActiveRecord::Base

  def self.find_or_create_by_auth(auth_data)
    user = self.find_or_create_by(provider: auth_data["provider"], uid: auth_data["uid"])
    if user.name != auth_data["info"]["name"]
      user.name = auth_data["info"]["name"]
      user.save
    end
    user
  end
end
