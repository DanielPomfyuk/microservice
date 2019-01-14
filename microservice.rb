require "rubygems"
require "sinatra"
require "sinatra/activerecord"
require "json"
require 'sinatra/base'
require 'sinatra/param'
require_relative 'models/profile.rb'
require_relative 'models/transaction.rb'
set :database, {adapter: "sqlite3", database: "foo.sqlite3"}

helpers Sinatra::Param
before do
  content_type 'application/json'
end

post '/add_user' do
    param :first_name,  String, required: true , blank:false
    param :last_name,   String, required: true , blank:false
    param :email,       String, required: true , blank:false
    param :password,    String, required: true , blank:false
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
  param :payer_id, Integer, required: true , blank:false
  param :payee_id, Integer, required: true , blank:false
  param :amount, Float, required: true , blank:false
  param :currency, String, in: ['dollar', 'euro','pound']

  newTransaction = Transaction.new
  result = {:status => nil ,:message => nil}
  payer = Profile.find(params['payer_id'])
  payee = Profile.find(params['payee_id'])
  newTransaction.payer = payer
  newTransaction.payee = payee
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

get '/get_users_info' do
  user = Profile.find(params['user_id'])
  user.to_json
end
get '/get_transaction' do
  transaction = Transaction.find(params['transaction_id'])
  transaction.to_json
end
get '/get_all_transactions' do
  user = Profile.find(params['user_id'])
  transactions = user.transactions
  transactions.to_json
end