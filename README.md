# Trump tweets charts
An interview assigment

## The assigment

### Overview

By using the data here (http://trumptwitterarchive.com/data/realdonaldtrump/2018.json),
your creation must download all of his tweets from 2014, and graph over time:
1) how many times he mentioned the word "democracy" to date?
2) which word did he mention more times - "China" or "Russia"?
3) Which one of his children's names did he mention most times?

### Requirements

Use GraphQL, Rails, React for your solution
Download the JSONs
You should have at least 3 graphs of the data:
1) times he mentioned the word "democracy"
2) instances "China" vs. "Russia"?
3) instances of mentioning his children's names

## Implementation Overview

I've built an React client and Rails GraphQL API.

The API serves aggregations over tweets of Donald Trump. The following assumtions and trade-offs were made:
 - the tweets data is preliminary preloaded, not dynamically fetched
 - the 'democracy' mentions are per year - not per date, not overall.
 - the mentions "China" vs "Russia" are calculated in total for the whole period
 - the mentions his childre are calculated in total for the whole period
 - all words are queried insensitive due to simplicity and explicty. There is a mechanics of finding different versions of a word.

## Setup

Pre-requiremets: ruby, bundler, docker-compose, node, yarn

### Backend

Steps:
1. Open repo's folder
2. Open the api foler
```
cd api
```
3. Install library dependecies
```
bundle install
```
4. Setup service dependecies
```
docker-compose up
```
5. Create and seed the DB
```
bundle exec rails db:setup && bundle exec rails fetch_tweets && bundle exec db:seed
```
6. Start the server
```
bundle exec rails s
```


### Frontend

1. Open repo's folder
2. Open the client foler
```
cd client
```
3. Install dependecies
```
yarn install
```
4. Start the app
```
yarn start
```
