require 'sinatra'
require_relative 'boot'

set :public_folder, File.expand_path(File.join(__dir__, '..', 'public'))

before do
  expires 120, :public, :must_revalidate
end

get '/api/live' do
  content_type :json
  { stations: %w(one two).map { |s| Station.new(name: s) } }.to_json
end
