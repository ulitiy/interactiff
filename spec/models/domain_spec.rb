require 'spec_helper'

describe Domain do
  subject { Factory(:domain) }
  it { should have_many(:hosts).dependent(:destroy) }
  it { should have_many(:games).dependent(:destroy) }
  it { should belong_to(:main_host) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:hosts_attributes) }
  it { should allow_mass_assignment_of(:main_host_id) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
