# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  state                  :string(255)
#  activation_token       :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password

  before_save { email.downcase! }
  before_save { generate_token(:remember_token) }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, :unless => Proc.new { |user| user.password.nil? }
  validates :password_confirmation, presence: true, :unless => Proc.new { |user| user.password.nil? }

# Mailers
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.password_reset(self).deliver
  end

  def send_activation_token
    generate_token(:activation_token)
    save!(:validate => false)
    UserMailer.user_activation(self).deliver
  end

# State Machine
  state_machine :initial => :inactive do
    event :activate do
      transition :inactive => :active
      transition :active   => :active
    end
  end

private

    def generate_token(colum)
      begin
        self[colum] = SecureRandom.urlsafe_base64
      end while User.exists?(colum => self[colum])
    end
end
