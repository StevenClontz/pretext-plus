class Invitation < ApplicationRecord
  belongs_to :owner_user, class_name: "User"
  belongs_to :recipient_user, class_name: "User", required: false

  def used?
    recipient_user_id.present?
  end

  def self.create_from_first_user
    self.create owner_user: User.first
  end
end
