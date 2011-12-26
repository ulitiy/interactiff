require 'spec_helper'

describe Host do
  subject { Factory(:host) }
  it { should belong_to(:domain) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:domain_id) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:domain) }
  it { should validate_uniqueness_of(:name) }
end
