# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  country_id :integer
#  state      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Region do
  pending "add some examples to (or delete) #{__FILE__}"
end
