require 'net/http'

task :fetch_tweets do
  all_tweets =
    (2014..2020).reduce([]) do |tweets, year|
      response = Net::HTTP.get_response(URI("http://trumptwitterarchive.com/data/realdonaldtrump/#{year}.json"))

      raise response unless response.is_a?(Net::HTTPSuccess)

      new_tweets = JSON.parse(response.body)
      puts "Fetching #{new_tweets.count} tweets from #{year}..."

      tweets += new_tweets
      tweets
    end

  file_path = Rails.root.join('storage', 'trump_tweets.json')
  File.open(file_path, 'w') do |file|
    data = JSON.pretty_generate(all_tweets)
    file.write(data)
  end

  puts "Saved #{all_tweets.count} tweets in #{file_path}"
end
