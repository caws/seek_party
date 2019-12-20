require 'active_record' unless defined? ActiveRecord
require_relative 'search_party/search_party_attribute'
require_relative 'search_party/search_party_engine'
require_relative 'search_party/search_party_query'
require_relative 'search_party/version'

module SearchParty
  DEFAULT_BLACK_LIST = %w[id created_at updated_at].freeze

  # Method below triggers all the magic
  def search(params: [], black_list: DEFAULT_BLACK_LIST, white_list: nil)
    # If there are params to work with, use SearchParty.
    # Otherwise, just return the Class itself.
    if params.nil?
      self
    else
      puts params
      SearchPartyEngine
          .new(params,
               self,
               white_list: white_list,
               black_list: black_list)
          .search
    end
  end
end