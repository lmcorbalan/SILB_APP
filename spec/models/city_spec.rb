# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  region_id  :integer
#  state      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe City do
  pending "add some examples to (or delete) #{__FILE__}"
end
