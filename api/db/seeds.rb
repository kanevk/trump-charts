raw_data = File.read(Rails.root.join('db', 'trump_tweets.json'))
tweets_data = JSON.parse(raw_data)

time_now = DateTime.current
batch_data =
  tweets_data.map do |tweet_data|
    {
      remote_id: tweet_data['id_str'],
      text: tweet_data['text'],
      published_at: tweet_data['created_at'],
      created_at: time_now,
      updated_at: time_now
    }
  end

puts "Seeding #{batch_data.count} tweets..."
Tweet.insert_all(batch_data)

puts 'Done.'
