class Profile < ActiveRecord::Base
  has_many :recieving_transactions, class_name: "Transaction", foreign_key: "payee_id"
  has_many :giving_transactions, class_name: "Transaction", foreign_key: "payer_id"
  has_many :reviews
  validates :first_name, :last_name, :email, :password, presence: true
  def recalculate_balance
    recieving_transactions = calculate_sum(self.recieving_transactions)
    giving_transactions = calculate_sum(self.giving_transactions)
    self.balance = recieving_transactions - giving_transactions
    self.save!
  end

  def recalculate_rating
    ratings = self.reviews.map {|review| review.rating}
    self.rating = (ratings.inject(0) {|sum, rate| sum += rate}.to_f) / ratings.size
    self.save!
  end
  private
  def calculate_sum(transactions)
    transactions.inject(0) do |sum,transaction|
      sum+=transaction.amount
    end.to_f
  end
end
