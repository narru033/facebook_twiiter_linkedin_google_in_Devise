class OmniauthCallbacksController < Devise::OmniauthCallbacksController
=begin
	def facebook     
     @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)      
     	if @user.persisted?       
		    sign_in_and_redirect @user, :event => :authentication
		    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    	else
		    session["devise.facebook_data"] = request.env["omniauth.auth"]
		    redirect_to new_user_registration_url
    	end
  end
  
  def google_oauth2
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
		  if @user.persisted?
		    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
		    sign_in_and_redirect @user, :event => :authentication
		  else
		    session["devise.google_data"] = request.env["omniauth.auth"]
		    redirect_to new_user_registration_url
		  end
  end
  
  def linkedin
    auth = env["omniauth.auth"]
    @user = User.connect_to_linkedin(request.env["omniauth.auth"],current_user)
		  if @user.persisted?
		    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "LInkedIn"
		    sign_in_and_redirect @user, :event => :authentication
		  else
		    session["devise.linkedin_data"] = request.env["omniauth.auth"]
		    redirect_to new_user_registration_url
		  end
  end
=end 

	def twitter
    @user = User.from_omniauth(request.env["omniauth.auth"],current_user)
			if @user.persisted?
			  session[:user_id] = @user.id
			  flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
			  sign_in_and_redirect @user, :event => :authentication
			else
			  session["devise.user_attributes"] = @user.attributes
			  redirect_to new_user_registration_url
			end
  end

	def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:google_oauth2, :facebook, :linkedin].each do |provider|
    provides_callback_for provider
  end
end
