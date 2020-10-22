require 'net/http'

response = Net::HTTP.get_response(URI('http://trumptwitterarchive.com/data/realdonaldtrump/2018.json'))

raise response.body if response.code != '200'

tweets_data = JSON.parse(response.body)

time_now = DateTime.current
batch_data =
  tweets_data.map do |tweet_data|
    { remote_id: tweet_data['id_str'], text: tweet_data['text'], published_at: tweet_data['created_at'], created_at: time_now, updated_at: time_now }
  end

puts "Seeding #{batch_data.count} tweets..."
Tweet.insert_all(batch_data)

puts 'Done.'
