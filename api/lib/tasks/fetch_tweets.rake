require 'net/http'

task :fetch_tweets do
  File.open(Rails.root.join('db', 'trump_tweets.json'), 'w') do |file|
    response = Net::HTTP.get_response(URI('http://trumptwitterarchive.com/data/realdonaldtrump/2014.json'))

    raise response unless response.is_a?(Net::HTTPSuccess)

    data = JSON.pretty_generate(JSON.parse(response.body))
    file.write(data)
  end
end
