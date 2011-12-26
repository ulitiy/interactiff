require 'spec_helper'

describe Hint do
  subject { Factory(:hint) }

  it{ should belong_to(:task) }

  it{ should allow_mass_assignment_of(:body) }

  it{ should validate_presence_of(:body) }
  it{ should validate_presence_of(:task) }
end
