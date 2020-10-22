require 'rails_helper'

RSpec.describe Tweet do
  describe '.countries_occurrences' do
    it 'counts multiple occurrences in a tweet' do
      create_tweets(
        'China, China is one of us',
        'Mother Russia > China'
      )

      expect(Tweet.countries_occurrences).to contain_exactly(
        an_object_having_attributes(name: 'China', number: 3),
        an_object_having_attributes(name: 'Russia', number: 1)
      )
    end

    it "doesn't match derivative words" do
      create_tweets(
        'I love mother Russia',
        "I'm russian spy"
      )

      expect(Tweet.countries_occurrences).to contain_exactly(
        an_object_having_attributes(name: 'Russia', number: 1),
        an_object_having_attributes(name: 'China', number: 0)
      )
    end

    it 'matches only case sensitive occurrences' do
      create_tweets(
        'China is one of us',
        'china uncensored'
      )

      expect(Tweet.countries_occurrences).to contain_exactly(
        an_object_having_attributes(name: 'China', number: 1),
        an_object_having_attributes(name: 'Russia', number: 0)
      )
    end
  end

  def create_tweets(*texts)
    texts.map.with_index do |text, i|
      Tweet.create!(text: text, remote_id: i, published_at: DateTime.current)
    end
  end

end
