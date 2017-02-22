require 'sinatra'
require_relative 'boot'

before do
  expires 120, :public, :must_revalidate
end

get '/api/live' do
  content_type :json
  { stations: %w(one two).map { |s| Station.new(name: s) } }.to_json
end
