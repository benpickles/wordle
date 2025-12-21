require 'minitest/autorun'
require_relative 'result'

describe Result do
  it 'works' do
    results = Result.parse(
      'Wordle 909 3/6

⬜🟩⬜⬜🟨
🟩🟩⬜🟩⬜
🟩🟩🟩🟩🟩'
    )
    result = results.first

    assert_equal 909, result.number
  end

  it 'works when the number formatting includes a comma' do
    results = Result.parse(
      'Wordle 1,013 2/6

🟩⬜🟨⬜🟨
🟩🟩🟩🟩🟩'
    )
    result = results.first

    assert_equal 1013, result.number
  end

  it 'works with hard mode results' do
    results = Result.parse(
      'Wordle 1,562 5/6*

⬜🟩⬜⬜🟨
⬜🟩⬜🟩⬜
⬜🟩⬜🟩⬜
⬜🟩🟨🟩🟩
🟩🟩🟩🟩🟩'
    )
    result = results.first

    assert_equal 1562, result.number
  end
end
