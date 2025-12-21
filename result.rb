Result = Data.define(:lines, :number, :score) do
  def self.parse(text)
    text
      .split(/^Wordle /)
      .map(&:strip)
      .reject(&:empty?)
      .map { |day|
        stats, *lines = day.split(/\n+/)
        match = stats.match(/^([\d,]+) ([1-6X])\/6\*?$/)
        number = match[1].delete(',').to_i
        score = match[2] == 'X' ? nil : match[2].to_i

        new(lines:, number:, score:)
      }
  end

  def chars
    lines.flat_map { |line|
      line.each_char.to_a
    }
  end
end
