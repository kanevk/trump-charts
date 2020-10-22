class Tweet < ApplicationRecord
  CHILDREN_NICKNAMES_BY_FIRST_NAME = {
    'Ivanka' => ['Ivanka'],
    'Barron' => ['Barron'],
    'Donald' => ['Don jr', 'Don Jr', 'Don JR', 'Donald Trump jr', 'Donald Trump Jr', 'Donald Trump JR'],
    'Tiffany' => ['Tiffany'],
    'Eric' => ['Eric']
  }.freeze

  Occurrency = Struct.new(:name, :number, keyword_init: true)

  def self.find_countries_occurrences
    find_occurrences({ 'China' => ['China'], 'Russia' => ['Russia'] })
  end

  def self.find_children_occurrences
    find_occurrences(CHILDREN_NICKNAMES_BY_FIRST_NAME)
  end

  def self.find_occurrences(word_instances_by_slug)
    words = word_instances_by_slug.values.flatten
    matching_texts = Tweet.where("text ~* '.*(#{words.join('|')}).*'").pluck(:text)

    empty_matches_per_slug = word_instances_by_slug.transform_values { [] }
    matches_per_slug =
      matching_texts.each_with_object(empty_matches_per_slug) do |text, word_occurrences|
        word_instances_by_slug.each do |slug, word_instances|
          word_occurrences[slug] += text.scan(/#{word_instances.join('|')}/)
        end
      end

    matches_per_slug.map { |slug, matches| Occurrency.new(name: slug, number: matches.count) }
  end
end
