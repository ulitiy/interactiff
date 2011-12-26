require 'spec_helper'

describe Answer do
  subject { Factory(:answer) }

  it{ should belong_to(:task) }

  it{ should allow_mass_assignment_of(:body) }

  it{ should validate_presence_of(:body) }
  it{ should validate_presence_of(:task) }
end
