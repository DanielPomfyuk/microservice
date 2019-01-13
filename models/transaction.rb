class Transaction < ActiveRecord::Base
  before_create :add_time_and_date
  enum currency: [ :dollar, :euro, :pound ]
belongs_to :profile
  private
  def add_time_and_date
    self.made_at = Time.now
  end
end