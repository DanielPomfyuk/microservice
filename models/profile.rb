class Profile < ActiveRecord::Base
  has_many :transactions
  validates :first_name, :last_name, :email, :password, presence: true

  def recalculate_balance
    transactions = self.transactions
    balance = 0.0
    transactions.each do |transaction|
      balance += transaction.amount
    end
    self.balance = balance
    self.save!
  end
end