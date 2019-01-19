describe Profile do
  before(:each) do
    @user = Profile.new
    @newTransaction = Transaction.new
    @second_user = Profile.new
  end
  describe '#validators' do
    it 'fails on attempt of saving profile instance without any param' do
      expect {
        @user.save!
      }.to raise_error(ActiveRecord::RecordInvalid,
                       'Validation failed: First name can\'t be blank, Last name can\'t be blank, '\
                       'Email can\'t be blank, Password can\'t be blank')
    end
    it 'fails on attempt of saving profile instance without first_name' do
      expect {
        @user.last_name = "Johns"
        @user.email = 'example@gmail.com'
        @user.password = 'koroziyametala'
        @user.save!
      }.to raise_error(ActiveRecord::RecordInvalid,
                       'Validation failed: First name can\'t be blank')
    end
    it 'fails on attempt of saving profile instance without last_name' do
      expect {
        @user.first_name = "John"
        @user.email = 'example@gmail.com'
        @user.password = 'koroziyametala'
        @user.save!
      }.to raise_error(ActiveRecord::RecordInvalid,
                       'Validation failed: Last name can\'t be blank')
    end
    it 'fails on attempt of saving profile instance without email' do
      expect {
        @user.first_name = "John"
        @user.last_name = 'Johns'
        @user.password = 'koroziyametala'
        @user.save!
      }.to raise_error(ActiveRecord::RecordInvalid,
                       'Validation failed: Email can\'t be blank')
    end
    it 'fails on attempt of saving profile instance without password' do
      expect {
        @user.first_name = "John"
        @user.last_name = 'Johns'
        @user.email = 'example@gmail.com'
        @user.save!
      }.to raise_error(ActiveRecord::RecordInvalid,
                       'Validation failed: Password can\'t be blank')
    end
    it 'fails on attempt of saving transaction without any params' do
      expect {
        @newTransaction.save!
      }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Payer can\'t be blank, Payee can\'t be blank,' \
          ' Amount can\'t be blank')
    end
    it 'fails on attempt of saving transaction without payee' do
      expect {
        @newTransaction.payer = @user
        @newTransaction.amount = 1000
        @newTransaction.currency = 'pound'
        @newTransaction.save!
      }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Payee can\'t be blank')
    end
    it 'fails on attempt of saving transaction without payer' do
      expect {
        @newTransaction.payee = @user
        @newTransaction.amount = 1000
        @newTransaction.currency = 'pound'
        @newTransaction.save!
      }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Payer can\'t be blank')
    end
    it 'fails on attempt of saving transaction without amount' do
      expect {
        @newTransaction.payee = @user
        @newTransaction.payer = @second_user
        @newTransaction.currency = 'pound'
        @newTransaction.save!
      }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Amount can\'t be blank')
    end
    it 'fails on attempt of saving transaction without currency' do
      expect {
        @newTransaction.payee = @user
        @newTransaction.payer = @second_user
        @newTransaction.amount = 1000
        @newTransaction.currency = 'hrivna'
        @newTransaction.save!
      }.to raise_error(ArgumentError, '\'hrivna\' is not a valid currency')
    end
  end
  describe '#racalculate methods' do
    before(:each) do
      @user.first_name = "John"
      @user.last_name = 'Johns'
      @user.email = 'example@gmail.com'
      @user.password = 'kokoko'
      @user.save!
      @second_user = Profile.new
      @second_user.first_name = 'Mike'
      @second_user.last_name = 'Adams'
      @second_user.email = 'secondguy@gmail.com'
      @second_user.password = 'aaaaa'
      @second_user.save!
    end
    it 'recalculates user`s rating and returns 0 if he has no reviews' do
      @user = Profile.new
      @user.recalculate_rating
      expect(@user.rating).to eql(0.0)
    end
    it 'recalculates user`s rating after receiving several reviews' do
      firstReview = Review.new
      firstReview.profile = @user
      firstReview.comment = 'it was ok'
      firstReview.rating = 5
      firstReview.save!
      @user.reload
      secondReview = Review.new
      secondReview.profile = @user
      secondReview.comment = 'it was awful'
      secondReview.rating = 1
      secondReview.save!
      @user.reload
      expect(@user.rating).to eql(3.0)
    end
    it 'racalculates new user`s balance and returns 0 if he has zero transactions' do
      @user.recalculate_balance
      expect(@user.balance).to eql(0.0)
    end
    before(:each) do
      @secondTransaction = Transaction.new
    end
    it 'recalculates users balance after one transactions' do
      @newTransaction.payee = Profile.find(@user.id)
      @newTransaction.payer = Profile.find(@second_user.id)
      @newTransaction.amount = 500
      @newTransaction.currency = 'euro'
      @newTransaction.save!
      @user.reload
      expect(@user.balance).to eql(500.0)
    end
    it 'recalculates users balance after several transactions' do
      @newTransaction.payee = @user
      @newTransaction.payer = @second_user
      @newTransaction.amount = 500
      @newTransaction.currency = 'euro'
      @newTransaction.save!
      @user.reload
      @secondTransaction.payee = @second_user
      @secondTransaction.payer = @user
      @secondTransaction.amount = 1000
      @secondTransaction.currency = 'euro'
      @secondTransaction.save
      @user.reload
      expect(@user.balance).to eql(-500.0)
    end
  end
end