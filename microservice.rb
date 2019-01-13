require "rubygems"
require "sinatra"
require "sinatra/activerecord"
require "json"
require_relative 'models/profile.rb'
require_relative 'models/transaction.rb'
set :database, {adapter: "sqlite3", database: "foo.sqlite3"}
get '/' do
  "Hello World"
end
post '/add_user' do
  content_type 'application/json'
  newUser = Profile.new
  result = {:status => nil,:message => nil}
  newUser.first_name = params['first_name']
  newUser.last_name = params['last_name']
  newUser.email = params['email']
  newUser.password = params['password']
  newUser.phone_number = params['phone_number']
  if newUser.save!
    result[:status] = "success"
    result[:message] = "your profile was created successfully"
  else
    result[:status] = "failure"
    result[:message] = "something went wrong"
  end
  result.to_json
end

post '/add_transaction' do
  content_type 'application/json'
  newTransaction = Transaction.new
  result = {:status => nil ,:message => nil}
  newTransaction.payee = params['payee']
  profile = Profile.find(params['user_id'])
  newTransaction.profile = profile
  newTransaction.payer = params['payer']
  newTransaction.currency = params['currency']
  newTransaction.amount = params['amount']
  if newTransaction.save!
    result[:status] = "success"
    result[:message] = "your transaction was made successfully"
  else
    result[:status] = "failure"
    result[:message] = "something went wrong"
  end
  result.to_json
end