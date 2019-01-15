class Transaction < ActiveRecord::Base
  before_create :add_time_and_date
  after_create :recalculate_users_balance
  enum currency: [ :dollar, :euro, :pound ]
  validates :payer,:payee,:amount,:currency, presence: true
  belongs_to :payer, class_name: "Profile", foreign_key: "payer_id"
  belongs_to :payee, class_name: "Profile", foreign_key: "payee_id"
  private
  def add_time_and_date
    self.made_at = Time.now
  end
  def recalculate_users_balance
    self.payer.recalculate_balance
    self.payee.recalculate_balance
  end
end