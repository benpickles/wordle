require 'phlex'
require 'sinatra'
require_relative 'result'

module Phlex
  class HTML
    def url(...)
      @_view_context.url(...)
    end
  end
end

class Layout < Phlex::HTML
  def template(&)
    doctype
    html(lang: 'en') {
      head {
        meta charset: 'utf-8'
        meta content: 'width=device-width', name: 'viewport'
        title { 'My Wordle results' }
        link href: url('/app.css', false), rel: 'stylesheet', type: 'text/css'
      }
      body {
        yield_content(&)
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

  def template
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
  def initialize(result)
    @result = result
  end

  def template
    article {
      header {
        h1 { @result.number }
        plain "#{@result.score || 'X'}/6"
      }
      div(class: 'lines') {
        @result.chars.each { |char|
          cell(char)
        }
      }
    }
  end

  def cell(char)
    method(elem_name(char)).call { char }
  end

  # A short element name for each type of value helps to significantly reduce
  # the final HTML file size - and is somewhat semantic...
  def elem_name(char)
    case char
    when '🟩'
      # "Correct" in Wordle, or "Bring Attention To" in HTML.
      :b
    when '🟨'
      # "Present" in Wordle, or "Idiomatic Text" in HTML.
      :i
    else
      # "Absent" in Wordle, or "Unarticulated Annotation" in HTML.
      :u
    end
  end
end

get '/' do
  results = Result.parse(File.read('results.txt')).reverse
  IndexPage.new(results).call(view_context: self)
end
