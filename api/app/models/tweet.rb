class Tweet < ApplicationRecord
  Occurrency = Struct.new(:name, :count, keyword_init: true)

  def self.countries_occurrences
    china_occurrences, russia_occurrences =
      Tweet.where("text LIKE '%China%' OR text LIKE '%Russia%'")
           .pluck("count(*) FILTER (where text LIKE '%China%')", "count(*) FILTER (where text LIKE '%Russia%')")
           .first

    [
      Occurrency.new(name: 'China', count: china_occurrences),
      Occurrency.new(name: 'Russia', count: russia_occurrences)
    ]
  end
end
