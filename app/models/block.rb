class Block < ActiveRecord::Base
  acts_as_citier

  belongs_to :parent
end
