class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers  
  has_many :events
  attr_accessible :firstname, :lastname, :email, :password, :password_confirmation
  validates :firstname, :lastname, :email, :password, :password_confirmation, presence: true
  validates :email, uniqueness: { case_sensitive: false }, :format => { :with => /\b[A-Z0-9._%a-z-]+@(?:[A-Z0-9a-z-]+.)+[A-Za-z]{2,4}\z/ }
  has_secure_password 
           
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.firstname = auth.info.first_name
      user.lastname = auth.info.last_name
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.password = auth.credentials.token
      user.password_confirmation = auth.credentials.token
      if user.save
        return user
      else 
        return nil
      end
    end
  end	

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
end
