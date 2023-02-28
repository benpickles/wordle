require 'sinatra'
require_relative 'result'

helpers do
  def class_name(char)
    case char
    when '🟩'
      'c' # correct
    when '🟨'
      'p' # present
    else
      'a' # absent
    end
  end
end

get '/' do
  @results = Result.parse(File.read('results.txt')).reverse
  erb :index
end
