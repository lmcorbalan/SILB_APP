# == Schema Information
#
# Table name: pictures
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  image          :string(255)
#  imageable_id   :integer
#  imageable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Picture < ActiveRecord::Base
  attr_accessible :image, :name

  belongs_to :imageable, :polymorphic => true

  mount_uploader :image, ImageUploader

  before_create :default_name

  def default_name
    self.name ||= File.basename(image.filename, '.*').titleize if image
  end

  include Rails.application.routes.url_helpers
  def to_jq_upload
    {
      "name"          => read_attribute(:name),
      "size"          => image.size,
      "url"           => image.url,
      "thumbnail_url" => image_url(:thumb),
      "delete_url"    => admin_picture_path(:id => id),
      "delete_type"   => "DELETE"
    }
  end

end
