require 'spec_helper'

describe Task do
  subject { Factory(:task) }
  it { should belong_to(:game) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:hints).dependent(:destroy) }

  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :comment }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:game) }
end
