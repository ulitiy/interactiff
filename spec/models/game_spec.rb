require 'spec_helper'

describe Game do
  subject { Factory(:game) }
  it { should belong_to(:domain) }
  it { should have_many(:tasks).dependent(:destroy) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:tasks_attributes) }

  it { should validate_presence_of(:domain) }
  it { should validate_presence_of(:name) }
end
