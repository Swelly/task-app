require "rails_helper"

describe TeamMembershipInvitation do
  let(:user) { create(:user) }
  let(:invited_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:team) { create(:team) }

  it "can be created" do
    invitation = build(:team_membership_invitation)
    invitation.save!
    expect(invitation).to be_persisted
    expect(invitation.class).to eq(TeamMembershipInvitation)
  end

  it "must have invited_user" do
    invitation = build(:team_membership_invitation, invited_user: nil, user: user, team: team)
    expect { invitation.save! }.to raise_error
  end

  it "must have invited_user who is not already a member of the team" do
    team.members << invited_user
    invitation = build(:team_membership_invitation, invited_user: invited_user, user: user, team: team)
    expect { invitation.save! }.to raise_error
    assert(invitation.invalid?)
    assert(["is already a member"] == invitation.errors.messages[:invited_user_id])
  end

  it "is unique for a given invited_user, user, and team" do
    create(:team_membership_invitation, invited_user: invited_user, user: user, team: team)
    duplicate = build(:team_membership_invitation, invited_user: invited_user, user: user, team: team)
    assert(duplicate.invalid?)
  end

  it "is unique for team" do
    create(:team_membership_invitation, invited_user: invited_user, user: user, team: team)
    duplicate = build(:team_membership_invitation, invited_user: other_user, user: user, team: team)
    assert(duplicate.invalid?)
  end

  describe ".make" do
    subject { TeamMembershipInvitation.make(user, invited_user, team) }

    it "creates a team_membership_invitation" do
      expect{ subject }.to change(TeamMembershipInvitation, :count).by(1)
    end

    it "gives the team_membership_invitation the specified attributes" do
      invitation = subject
      assert(invitation.class == TeamMembershipInvitation)
      assert(invitation.persisted?)
      assert(team == invitation.team)
      assert(user == invitation.user)
      assert(invited_user == invitation.invited_user)
    end
  end
end
