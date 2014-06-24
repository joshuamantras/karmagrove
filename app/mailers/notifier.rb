class Notifier < ActionMailer::Base
  default :from => 'seeds@karmagrove.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
  	begin
      @user   = user
      mail(
        to: @user.email,
        subject: 'Thanks for signing up Karma Grove.  We will email you monthly with updates as to where donations have gone as well as keep you up to date on any new features.',
        template_path: 'notifier',
        template_name: 'welcome_email'
      )
    rescue Exception => e
    	Rails.logger.info e
      return true
    end  
  end

  def send_purchase_email(params={})

    # hard code buddh links for now Buddha.create_links
    @buddha_links = ["https://s3.amazonaws.com/karmagrove/Archive.zip","https://s3.amazonaws.com/karmagrove/Archive2.zip","https://s3.amazonaws.com/karmagrove/Archive3.zip"]
      
    begin
      @user = params[:user]
      @purchase = params[:purchase]
      mail(
        to: @user.email,
        subject: 'Thank you for your purchase at the grove',
        template_path: 'buddhas',
        template_name: 'purchase_email'
      )
    rescue Exception => e
      Rails.logger.info e
      return true
    end  
  end

end
