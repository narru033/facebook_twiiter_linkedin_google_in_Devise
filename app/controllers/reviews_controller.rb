class ReviewsController < ApplicationController
	def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.create!(review_params)
		  if current_user.provider == "facebook"
		  	#@facebook.put_connections("me", "feed", :message => @review.content)
		    #current_user.facebook.put_object("me", "feed", :message => @review.content)
		    current_user.post(@review.content)
		  elsif current_user.provider == "twitter"
		    current_user.post_tweets(@review.content)
		  elsif current_user.provider == "linkedin"
		    current_user.post_update(@review.content)
		  end
    redirect_to @review.product, notice: "Comment has been created."
  end
  
=begin
  	def post
    msg = "#{Time.now}=>life is harmfull !! "
    #user = User.find_by_id params[:id]
    begin
      # if user.facebook_account and user.facebook_account.active 
      #   user.facebook_account.post(msg)
      #   #notice ='facebook '    
      # end

       if current_user
         current_user.user.post(msg)
         #notice += 'linkedin '    
       end
      redirect_to @review.product , :notice => "post sent success fully to #{notice}"
 
    rescue 
      redirect_to @review.product , :alert => 'something was wrong. try later.'

    end
  end  
=end
 	private
    def review_params
      params.require(:review).permit(:content,:name,:rating)
    end
end
