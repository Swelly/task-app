class TeamMembershipInvitation < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :invited_user, class_name: "User", touch: true
  belongs_to :team

  validates_presence_of :invited_user_id
  validates_uniqueness_of :invited_user_id, scope: [:user_id, :team_id]
  validates_uniqueness_of :team_id
  validate :not_already_a_member, on: :create

  attr_accessor :invited_user_email

  def self.make(user, invited_user, team)
    invitation = TeamMembershipInvitation.create(user: user, invited_user: invited_user, team: team)
    invitation
  end

private

  def not_already_a_member
    errors.add(:invited_user_id, "is already a member") if invited_user && invited_user.membership_in(team)
  end

end
