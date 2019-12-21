require 'active_record' unless defined? ActiveRecord
require_relative 'search_party/search_party_attribute'
require_relative 'search_party/search_party_engine'
require_relative 'search_party/search_party_query'
require_relative 'search_party/version'

module SearchParty
  DEFAULT_BLACK_LIST = %w[id created_at updated_at].freeze

  # Method below triggers all the magic
  def search(params: [],
             black_list: DEFAULT_BLACK_LIST,
             white_list: nil,
             scopes: [])
    # If there are params to work with, use SearchParty.
    # Otherwise, just return an empty instance of ActiveRecord_Relation.
    return none if params.empty?

    SearchPartyEngine
        .new(self,
             params: params,
             white_list: white_list,
             black_list: black_list,
             scopes: scopes)
        .search
  end
end