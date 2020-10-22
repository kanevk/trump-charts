require 'rails_helper'

RSpec.describe Tweet do
  describe '.find_countries_occurrences' do
    it 'counts multiple occurrences in a tweet' do
      create_tweets(
        'China, China is one of us',
        'Mother Russia > China'
      )

      expect(Tweet.find_countries_occurrences).to contain_exactly(
        an_object_having_attributes(name: 'China', number: 3),
        an_object_having_attributes(name: 'Russia', number: 1)
      )
    end

    it "doesn't match derivative words" do
      create_tweets(
        'I love mother Russia',
        "I'm russian spy"
      )

      expect(Tweet.find_countries_occurrences).to contain_exactly(
        an_object_having_attributes(name: 'Russia', number: 1),
        an_object_having_attributes(name: 'China', number: 0)
      )
    end

    it 'matches case insensitive occurrences' do
      create_tweets(
        'China is one of us',
        'CHINA uncensored'
      )

      expect(Tweet.find_countries_occurrences).to contain_exactly(
        an_object_having_attributes(name: 'China', number: 2),
        an_object_having_attributes(name: 'Russia', number: 0)
      )
    end
  end

  describe '.find_children_occurrences' do
    it 'includes results for all children' do
      expect(Tweet.find_children_occurrences).to contain_exactly(
        an_object_having_attributes(name: 'Ivanka'),
        an_object_having_attributes(name: 'Barron'),
        an_object_having_attributes(name: 'Donald'),
        an_object_having_attributes(name: 'Tiffany'),
        an_object_having_attributes(name: 'Eric')
      )
    end

    it 'counts multiple occurrences in a tweet' do
      create_tweets('Ivanka and Don jr. are not mine')

      expect(Tweet.find_children_occurrences).to include(
        an_object_having_attributes(name: 'Ivanka', number: 1),
        an_object_having_attributes(name: 'Donald', number: 1)
      )
    end

    it 'counts multiple variations of Donald' do
      create_tweets('Don jr.', 'Don JR.', 'Don Jr.',
                    'Donald Trump jr.', 'Donald Trump JR.', 'Donald Trump Jr.')

      expect(Tweet.find_children_occurrences).to include(
        an_object_having_attributes(name: 'Donald', number: 6)
      )
    end
  end

  describe '.find_democracy_occurrences_by_year' do
    it 'counts multiple occurrences in a tweet per year' do
      create_tweets('Corporative word for democracy', year: 2014)
      create_tweets('democracy', year: 2014)
      create_tweets('DEMOCRACY', year: 2015)

      expect(Tweet.find_democracy_occurrences_by_year).to include(
        2014 => an_object_having_attributes(name: 'Democracy', number: 2),
        2015 => an_object_having_attributes(name: 'Democracy', number: 1)
      )
    end

    it 'includes results for all years from 2014 to 2020' do
      create_tweets('democracy', year: 2014)

      expect(Tweet.find_democracy_occurrences_by_year.keys).to contain_exactly(
        2014, 2015, 2016, 2017, 2018, 2019, 2020
      )
    end
  end

  def create_tweets(*texts, year: 2020)
    last_remote_id = Tweet.maximum('remote_id') || 0
    texts.map.with_index do |text, i|
      Tweet.create!(text: text, remote_id: last_remote_id + i + 1, published_at: DateTime.new(year, 1, 1))
    end
  end

end
