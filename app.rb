require 'sinatra'
require_relative 'result'

helpers do
  def cell(char)
    name = elem_name(char)
    %(<#{name}>#{char}</#{name}>)
  end

  # A short element name for each type of value helps to significantly reduce
  # the final HTML file size - and is somewhat semantic...
  def elem_name(char)
    case char
    when '🟩'
      # "Correct" in Wordle, or "Bring Attention To" in HTML.
      'b'
    when '🟨'
      # "Present" in Wordle, or "Idiomatic Text" in HTML.
      'i'
    else
      # "Absent" in Wordle, or "Unarticulated Annotation" in HTML.
      'u'
    end
  end
end

get '/' do
  @results = Result.parse(File.read('results.txt')).reverse
  erb :index
end
