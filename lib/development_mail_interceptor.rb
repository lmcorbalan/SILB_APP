class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"        
    message.to = "silb.sap.uai2013@gmail.com"
  end    
end