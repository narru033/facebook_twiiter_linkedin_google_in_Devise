class User < ActiveRecord::Base
  # Twitter App keys
  CONSUMER_KEY = 'LOr3kATIeMeAaqZQW2xdropWW'
  CONSUMER_SECRET = 'kDEanaAwGl7bmbkjNnqrsrglbsBlM2qvm3mUhrDKCuEsxjcABM'
  OPTIONS = {site: "http://api.twitter.com", request_endpoint: "http://api.twitter.com"}

  # Linked App keys

  API_KEY = '75xbomi2tbfjii'
  API_SECRET = 'a3L54tojuqTIyF5x'
  #API_KEY = 'ehpf2cwwrle0'
  #API_SECRET = 'nN6EzLKFNTrOIMaq'
   
	has_many :reviews
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable,:timeoutable,:confirmable,:omniauthable
         
  # All Provoiders
  def self.find_for_oauth(auth, signed_in_resource = nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name: auth.info.first_name,
                           provider: auth.provider,
                           uid: auth.uid,
                           user_name: auth.info.screen_name,
                           email: auth.info.email,
                           oauth_token: auth.credentials.token,
                           token_secret: auth.credentials.secret,
     					             #oauth_expires_at = Time.at(auth.credentials.expires_at.to_s)
      					           oauth_expires_at: DateTime.current >> 2,
                           password: Devise.friendly_token[0,20],
                          )
      end
    end
  end 
  
  # Facebook
=begin
	def self.find_for_oauth(auth, signed_in_resource = nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create( name: auth.extra.raw_info.name,
				 										provider: auth.provider,
				            				uid: auth.uid,
								            email: auth.info.email,
								            oauth_token: auth.credentials.token,
								            oauth_expires_at: Time.at(auth.credentials.expires_at),
								            password:Devise.friendly_token[0,20],
                          )
      end
    end
  end
=end 

	#Facebook Post
	def post(message)
		@facebook = Koala::Facebook::API.new(oauth_token)    
		profile = @facebook.get_object("me")
		@facebook.put_wall_post(:message => message) 
	end

=begin 
  def facebook
    @facebook = Koala::Facebook::API.new(oauth_token)
    profile = @facebook.get_object("me")
		friends = @facebook.get_connections("me", "permissions")
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end
 
 
  def friends_count
    facebook { |fb| fb.get_connection("me", "friends").size }
  end

  # Google

  def self.find_for_oauth(auth, signed_in_resource = nil)
    data = auth.info
    user = User.where(:provider => auth.provider, :uid => auth.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(	name: data["name"],
									          provider:auth.provider,
									          email: data["email"],
									          uid: auth.uid,
									          password: Devise.friendly_token[0,20],
        									)
      end
   	end
	end
=end

  #Twitter
	def self.from_omniauth(auth,signed_in_resource = nil)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.name			=	auth.extra.raw_info.name
			user.provider = auth.provider 
			user.uid      = auth.uid
			user.oauth_token = auth.credentials.token
			user.token_secret= auth.credentials.secret
      #user.oauth_expires_at = Time.at(auth.credentials.expires_at.to_s)
      user.oauth_expires_at = DateTime.current >> 2
			user.save
    end
	end
	
	def self.new_with_session(params, session)
		if session["devise.user_attributes"]
			new(session["devise.user_attributes"], without_protection: true) do |user|
				user.attributes = params
				user.valid?
			end
		else
			super
		end
	end
	
	def password_required?
		super && provider.blank?
	end
	#Twitter Tweets
	def post_tweets(message)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = User::CONSUMER_KEY
      config.consumer_secret = User::CONSUMER_SECRET
      config.oauth_token = oauth_token
      config.oauth_token_secret = token_secret
    end
    #client = Twitter::Client.new
    begin
      client.update(message)
      return true
    rescue Exception => e
      self.errors.add(:oauth_token, "Unable to send to twitter: #{e.to_s}")
      return false
    end
  end
  
=begin
	# LinkedIn  
	def self.find_for_oauth(auth, signed_in_resource = nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name: auth.info.first_name,
                           provider: auth.provider,
                           uid: auth.uid,
                           user_name: auth.info.screen_name,
                           email: auth.info.email,
                           oauth_token: auth.credentials.token,
                           token_secret: auth.credentials.secret,
     					             #oauth_expires_at = Time.at(auth.credentials.expires_at.to_s)
      					           oauth_expires_at: DateTime.current >> 2,
                           password: Devise.friendly_token[0,20],
                          )
      end
    end
  end
=end
 
	# LinkedIn Updates
	def post_update(message)
		client  = LinkedIn::Client.new(User::API_KEY, User::API_SECRET)
		client.authorize_from_access(oauth_token,token_secret)
		client.add_share({:comment => message})
	end
	
=begin
  def profile
    client  = LinkedIn::Client.new(User::API_KEY,User::API_SECRET)

    client.authorize_from_access(oauth_token,token_secret)
    client.profile   
  end

  def connections
    client  = LinkedIn::Client.new(User::API_KEY,User::API_SECRET)
    
    client.authorize_from_access(oauth_token,token_secret)
    client.connections
  end
	# oauth = LinkedIn::Oauth.new(linkedin_api_key, linkedin_secret)
=end

end
