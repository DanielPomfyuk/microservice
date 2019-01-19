class Review < ActiveRecord::Base
  belongs_to :profile
  after_save :recalculate_users_rating
  private
  def recalculate_users_rating
    self.profile.recalculate_rating
  end
end