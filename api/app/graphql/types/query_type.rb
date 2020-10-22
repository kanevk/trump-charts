module Types
  class QueryType < Types::BaseObject
    CHILDREN_NAMES = ['Ivanka', 'Barron', 'Don jr.', 'Donald Trump Jr.', 'Tiffany', 'Eric'].freeze

    class Occurrency < Types::BaseObject
      field :name, String, null: false
      field :count, Integer, null: false
    end

    class TweetsAnalytics < Types::BaseObject
      field :countries_occurrences, [Occurrency], null: false
      def countries_occurrences
        Tweet.countries_occurrences.map { |occ| occ.to_h.slice(:name, :count) }
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
