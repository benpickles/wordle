require 'phlex-sinatra'
require 'sinatra'
require_relative 'result'

class Layout < Phlex::HTML
  def view_template
    doctype
    html(lang: 'en') {
      head {
        meta charset: 'utf-8'
        meta content: 'width=device-width', name: 'viewport'
        title { 'My Wordle results' }
        link href: url('/app.css', false), rel: 'stylesheet', type: 'text/css'
      }
      body {
        yield
        footer {
          p {
            plain 'A doodah by '
            a(href: 'https://www.benpickles.com') { 'Ben Pickles' }
            plain ' – '
            a(href: 'https://github.com/benpickles/wordle') { 'github.com/benpickles/wordle' }
          }
        }
      }
    }
  end
end

class IndexPage < Phlex::HTML
  def initialize(results)
    @results = results
  end

  def view_template
    render Layout.new {
      h1 { "My Wordle results" }
      main {
        @results.each { |result|
          render ResultComponent.new(result)
        }
      }
    }
  end
end

class ResultComponent < Phlex::HTML
  # A short element name for each type of value helps to significantly reduce
  # the final HTML file size - and is somewhat semantic...
  ELEM_NAME = {
    '🟩' => :b, # "Correct" in Wordle, or "Bring Attention To" in HTML.
    '🟨' => :i, # "Present" in Wordle, or "Idiomatic Text" in HTML.
    '⬜' => :u, # "Absent" in Wordle, or "Unarticulated Annotation" in HTML.
  }

  def initialize(result)
    @result = result
  end

  def view_template
    article {
      header {
        h1 { @result.number }
        plain "#{@result.score || 'X'}/6"
      }
      div {
        @result.chars.each { |char|
          method(ELEM_NAME.fetch(char)).call { char }
        }
      }
    }
  end
end

get '/' do
  results = Result.parse(File.read('results.txt')).reverse
  phlex IndexPage.new(results)
end
