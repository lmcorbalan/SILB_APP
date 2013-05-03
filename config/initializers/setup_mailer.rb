ActionMailer::Base::smtp_settings = {
    :address                => "smtp.gmail.com",
    :port                   => 587,
    :authentication         => "plain",
    :enable_starttls_auto   => true,
    :domain                 => ENV['GMAIL_SILB_SMTP_USER'],
    :user_name              => ENV['GMAIL_SILB_SMTP_USER'],
    :password               => ENV['GMAIL_SILB_SMTP_PASSWORD']
}

# Descomentar una vez finalizada la aplicacion
# if Rails.env.development?
    require 'development_mail_interceptor'
    ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
# end
