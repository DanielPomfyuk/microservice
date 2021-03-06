require "rubygems"
require "sinatra"
require "sinatra/activerecord"
require "json"
require "faraday"
require 'sinatra/base'
require 'sinatra/param'
require_relative 'models/profile.rb'
require_relative 'models/transaction.rb'
require_relative 'models/review.rb'
require_relative 'errors/data_base_error'
set :port, 3228
set :database, {adapter: "sqlite3", database: "foo.sqlite3"}
set :show_exceptions, :after_handler
helpers Sinatra::Param
before do
  content_type 'application/json'
end
# error 404 do
#   puts "\n\n\nIN 404 #{env['sinatra.error']}\n\n\n"
#   {:message => "there was something wrong with the request #{env['sinatra.error'].message}"}.to_json
# end
error ActiveRecord::StatementInvalid do
  DataBaseError.new(env['sinatra.error'].message, 500).return_json
end
error ActiveRecord::RecordNotFound do
  puts "IN EXCEPTION \n\n#{env['sinatra.error'].message}"
  DataBaseError.new(env['sinatra.error'].message,404).return_json
end
error DataBaseError do
  [env['sinatra.error'].status,{:message => env['sinatra.error'].message}.to_json ]
end
post '/add_user' do
  param :first_name, String, required: true, blank: false
  param :last_name, String, required: true, blank: false
  param :email, String, required: true, blank: false
  param :password, String, required: true, blank: false
  param :phone_number, String, required: true, blank: false
  param :encrypted_password, String, required: true, blank: false
  param :reset_password_token, String, required: true, blank: false
  param :remember_created_at, DateTime, required: true, blank: false
  param :created_at, DateTime, required: true, blank: false
  param :updated_at, DateTime, required: true, blank: false

  newUser = Profile.new
  newUser.first_name = params['first_name']
  newUser.last_name = params['last_name']
  newUser.email = params['email']
  newUser.password = params['password']
  newUser.phone_number = params['phone_number']
  newUser.encrypted_password = params['encrypted_password']
  newUser.reset_password_token = params['reset_password_token']
  newUser.remember_created_at = params['remember_created_at']
  newUser.created_at = params['created_at']
  newUser.updated_at = params['updated_at']

  create_handler(newUser, 'new user was successfully added')
end

post '/update_user/:user_id' do
  param :user_id, Integer, required: true, blank: false
  allowed_params = [:first_name, :last_name, :email, :password, :phone_number,
                    :encrypted_password, :reset_password_token, :remember_created_at,
                    :created_at, :updated_at]
  @user = Profile.find(params[:user_id])
  params.each do |key, value|
    if allowed_params.include? key.to_sym
      @user[key.to_sym] = value unless key.to_sym == :user_id
    end
  end
  create_handler(@user, 'your info was successfully updated')
end
post '/add_transaction' do
  param :payer_id, Integer, required: true, blank: false
  param :payee_id, Integer, required: true, blank: false
  param :amount, Float, required: true, blank: false
  param :currency, String, in: ['dollar', 'euro', 'pound']
  newTransaction = Transaction.new
  payer = Profile.find(params['payer_id'])
  payee = Profile.find(params['payee_id'])
  newTransaction.payer = payer
  newTransaction.payee = payee
  newTransaction.currency = params['currency']
  newTransaction.amount = params['amount']
  create_handler(newTransaction, 'your transaction was made successfully')
end
post '/add_review' do
  param :user_id, Integer, required: true, blank: false
  param :rating, Float, required: true, blank: false
  param :comment, String, required: true, blank: false
  user = Profile.find(params['user_id'])
  newReview = Review.new
  newReview.profile = user
  newReview.comment = params['comment']
  newReview.rating = params['rating']
  create_handler(newReview, 'your review was successfully added')
end

get '/get_users_info' do
  param :user_id, Integer, required: true, blank: false
  puts "\n\nINSIDE OF THE ROUTE\n\n"
  begin
    user = Profile.find(params['user_id'])
  rescue ActiveRecord::RecordNotFound => exc
   raise DataBaseError.new(exc.message,404)
  end
  user.to_json
end
get '/get_users_reviews' do
  param :user_id, Integer, required: true, blank: false
  user = Profile.find(params['user_id'])
  user.reviews.to_json
end
get '/get_transaction' do
  param :transaction_id, Integer, required: true, blank: false
  transaction = Transaction.find(params['transaction_id'])
  transaction.to_json
end
get '/get_all_transactions' do
  param :user_id, Integer, required: true, blank: false
  user = Profile.find(params['user_id'])
  receiving = user.recieving_transactions
  receiving.to_json
end
def create_handler(model, message)
  result = {}
  if model.save!
    result[:status] = 'success'
    result[:message] = rand(36).to_s(36)
  else
    result[:status] = "failure"
    result[:message] = "something went wrong"
  end
  result.to_json
end