require File.dirname(__FILE__) + "/../spec_helper"

describe Group do
  subject { Factory(:valid_group) }
  # it { should validate_uniqueness_of(:code) }
  it { should belong_to(:creator) }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:members).through(:memberships) }
  it { should have_many(:group_scenarios).dependent(:destroy) }
  it { should have_many(:scenarios).through(:group_scenarios) }
  it { should have_many(:notification_emails) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:creator_id) }
  it { should ensure_length_of(:name).is_at_most(200) }
  it { should validate_presence_of(:code) }
  it { should ensure_length_of(:code).is_at_most(200) }
  it { should validate_presence_of(:creator) }
  it { should validate_presence_of(:scenarios) }

  it { should respond_to :group_scenarios_attributes= }

  context "when creating a student group memberships" do
    let(:student) { Factory(:student, :group_code => subject.code) }

    it { expect { subject.create_memberships(student) }.to change(student.group_scenarios, :count).by(1) }
  end

end
