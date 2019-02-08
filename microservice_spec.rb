describe '#microservice' do
  describe "routes" do
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    it 'should reject post request with attempt to create a new user without any params' do
      post '/add_user'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['first_name']).to eql('Parameter is required')
    end
    it 'should reject post request with attempt to create a new user without last_name' do
      post '/add_user', params = {first_name: 'jack', email: "laalla@gmail.com", password: "password"}
      expect(last_response.status).to eql(400)
      response = JSON.parse(last_response.body)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['last_name']).to eql('Parameter is required')
    end
    it 'should reject post request with attempt to create a new user without email' do
      post '/add_user', params = {first_name: 'jack', last_name: 'Krupa', password: "password"}
      expect(last_response.status).to eql(400)
      response = JSON.parse(last_response.body)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['email']).to eql('Parameter is required')
    end
    it 'should reject post request with attempt to create a new user without password' do
      post '/add_user', params = {first_name: 'jack', last_name: 'Krupa', email: 'qmail@gmail.com'}
      expect(last_response.status).to eql(400)
      response = JSON.parse(last_response.body)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['password']).to eql('Parameter is required')
    end
    it 'should accept post request with attempt to create a new user ' do
      post '/add_user', params = {first_name: 'jack', last_name: 'Krupa', password: "password", email: 'emai@email.com'}
      expect(last_response.status).to eql(200)
      response = JSON.parse(last_response.body)
      expect(response['message']).to eql('new user was successfully added')
    end
    before(:each) do
      @user = Profile.new
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
    it 'should reject post request with attempt to create a new transaction without any params ' do
      post '/add_transaction'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['payer_id']).to eql('Parameter is required')
    end
    it 'should reject post request with attempt to create a new transaction without payee_id ' do
      post '/add_transaction', params = {payer_id: 1, amount: 1000, currency: "pound"}
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['payee_id']).to eql('Parameter is required')
    end
    it 'should reject post request with attempt to create a new transaction without amount ' do
      post '/add_transaction', params = {payer_id: 1, payee_id: 2, currency: "pound"}
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['amount']).to eql('Parameter is required')
    end
    it 'should reject post request with attempt to create a new transaction without wrong currency ' do
      post '/add_transaction', params = {payer_id: 1, payee_id: 2, amount: 100, currency: 'hrivna'}
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql("Parameter must be within [\"dollar\", \"euro\", \"pound\"]")
      expect(response['errors']['currency']).to eql("Parameter must be within [\"dollar\", \"euro\", \"pound\"]")
    end
    it 'should reject post request with attempt to create a new transaction without wrong currency ' do
      post '/add_transaction', params = {payer_id: 1, payee_id: 2, amount: 100, currency: 'hrivna'}
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql("Parameter must be within [\"dollar\", \"euro\", \"pound\"]")
      expect(response['errors']['currency']).to eql("Parameter must be within [\"dollar\", \"euro\", \"pound\"]")
    end
    it 'should accept post request with attempt to create a new transaction ' do
      post '/add_transaction', params = {payer_id: 1, payee_id: 2, amount: 100, currency: 'euro'}
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(200)
      expect(response['message']).to eql("your transaction was made successfully")
    end
    it 'should reject post request with attempt to create a new review without any params ' do
      post '/add_review'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['user_id']).to eql('Parameter is required')
    end
    it 'should reject post request with attempt to create a new review without rating' do
      post '/add_review', params = {user_id: 1, comment: 'it was ok'}
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['rating']).to eql('Parameter is required')
    end
    it 'should reject post request with attempt to create a new review without comment' do
      post '/add_review', params = {user_id: 1, rating: 3.0}
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['comment']).to eql('Parameter is required')
    end
    it 'should accept post request with attempt to create a new transaction ' do
      post '/add_review', params = {user_id: 1, rating: 3, comment: 'it was ok'}
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eql(200)
      expect(response['message']).to eql("your review was successfully added")
    end
    it 'should reject get request with attempt to get user`s info without his id' do
      get '/get_users_info'
      response = JSON(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['user_id']).to eql('Parameter is required')
    end
    it 'should accept get request with attempt to get user`s info ' do
      get '/get_users_info', params = {user_id: 1}
      expect(last_response.status).to eql(200)
    end
    it 'should reject get request with attempt to get user`s reviews without his id' do
      get '/get_users_reviews'
      response = JSON(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['user_id']).to eql('Parameter is required')
    end
    it 'should accept get request with attempt to get user`s reviews ' do
      get '/get_users_reviews', params = {user_id: 1}
      expect(last_response.status).to eql(200)
    end
    it 'should reject get request with attempt to get a transaction without it`s` id' do
      get '/get_transaction'
      response = JSON(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['transaction_id']).to eql('Parameter is required')
    end
    it 'should accept get request with attempt to get a transaction ' do
      get '/get_transaction', params = {transaction_id: 1}
      expect(last_response.status).to eql(200)
    end
    it 'should reject get request with attempt to get user`s transactions without his id' do
      get '/get_all_transactions'
      response = JSON(last_response.body)
      expect(last_response.status).to eql(400)
      expect(response['message']).to eql('Parameter is required')
      expect(response['errors']['user_id']).to eql('Parameter is required')
    end
    it 'should accept get request with attempt to get user`s transactions ' do
      get '/get_all_transactions', params = {user_id: 1}
      expect(last_response.status).to eql(200)
    end
    it 'should give a negative response on attempt to save invalid model' do
      class Fake
        def self.save!
          false
        end
      end
      expect(create_handler(Fake, 'ahahahhahahaha')).to eql({:status => 'failure', :message => 'something ' \
      'went wrong'}.to_json)
    end
  end
end