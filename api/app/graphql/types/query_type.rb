module Types
  class QueryType < Types::BaseObject
    CHILDREN_NAMES = ['Ivanka', 'Barron', 'Don jr.', 'Donald Trump Jr.', 'Tiffany', 'Eric'].freeze

    class WordOccurrences < Types::BaseObject
      field :name, String, null: false
      field :count, Integer, null: false
    end

    class WordOccurrencesByYear < Types::BaseObject
      field :name, String, null: false
      field :count, Integer, null: false
      field :year, Integer, null: false
    end

    class TweetsAnalytics < Types::BaseObject
      field :countries_occurrences, [WordOccurrences], null: false
      def countries_occurrences
        Tweet.find_countries_occurrences.map { |occ| { name: occ.name, count: occ.number } }
      end

      field :children_occurrences, [WordOccurrences], null: false
      def children_occurrences
        Tweet.find_children_occurrences.map { |occ| { name: occ.name, count: occ.number } }
      end

      field :democracy_by_year, [WordOccurrencesByYear], null: false
      def democracy_by_year
        Tweet.find_democracy_occurrences_by_year.map do |year, occ|
          { name: 'Democracy', count: occ.number, year: year }
        end
      end
    end
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :tweets_analytics, TweetsAnalytics, null: false, description: 'Analytics over the Trumps tweets'
    def tweets_analytics
      {}
    end
  end
end
