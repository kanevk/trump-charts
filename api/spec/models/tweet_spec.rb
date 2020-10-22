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

    it 'matches only case sensitive occurrences' do
      create_tweets(
        'China is one of us',
        'china uncensored'
      )

      expect(Tweet.find_countries_occurrences).to contain_exactly(
        an_object_having_attributes(name: 'China', number: 1),
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

  def create_tweets(*texts)
    texts.map.with_index do |text, i|
      Tweet.create!(text: text, remote_id: i, published_at: DateTime.current)
    end
  end

end
