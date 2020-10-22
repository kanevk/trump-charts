class Tweet < ApplicationRecord
  YEARS_WITH_DATA = 2014..2020
  CHILDREN_NICKNAMES_BY_FIRST_NAME = {
    'Ivanka' => ['Ivanka'],
    'Barron' => ['Barron'],
    'Donald' => ['Don jr', 'Don Jr', 'Don JR', 'Donald Trump jr', 'Donald Trump Jr', 'Donald Trump JR'],
    'Tiffany' => ['Tiffany'],
    'Eric' => ['Eric']
  }.freeze

  Occurrency = Struct.new(:name, :number, keyword_init: true)

  class << self
    def find_countries_occurrences
      find_occurrences({ 'China' => ['China', 'CHINA'], 'Russia' => ['Russia', 'RUSSIA'] })
    end

    def find_children_occurrences
      find_occurrences(CHILDREN_NICKNAMES_BY_FIRST_NAME)
    end

    # Here we make 8 queries, but we win simplicity
    def find_democracy_occurrences_by_year
      YEARS_WITH_DATA.reduce({}) do |count_by_year, year|
        range = Date.new(year, 1, 1)..Date.new(year, 12, 31)

        count_by_year.merge(year =>
          find_occurrences({ 'Democracy' => ['democracy', 'Democracy', 'DEMOCRACY'] }, time_range: range).first)
      end
    end

    def find_occurrences(word_instances_by_slug, time_range: nil)
      words = word_instances_by_slug.values.flatten
      tweet_texts = Tweet.where("text ~ '.*(#{words.join('|')}).*'")
                         .where(time_range ? { published_at: time_range } : {})
                         .pluck(:text)
      full_text = tweet_texts.join("\n")

      matches_by_slug = word_instances_by_slug.transform_values do |word_instances|
        full_text.scan(/#{word_instances.join('|')}/i)
      end

      matches_by_slug.map { |slug, matches| Occurrency.new(name: slug, number: matches.count) }
    end
  end
end
