require 'active_record' unless defined? ActiveRecord
require_relative 'seek_party/models/sp_attribute'
require_relative 'seek_party/models/sp_query'
require_relative 'seek_party/seek_party_attribute'
require_relative 'seek_party/seek_party_engine'
require_relative 'seek_party/seek_party_query_builder'
require_relative 'seek_party/version'

module SeekParty
  DEFAULT_BLACK_LIST = %w[id created_at updated_at].freeze

  # Method below triggers all the magic
  def search(params: [],
             black_list: DEFAULT_BLACK_LIST,
             white_list: nil,
             scopes: [])

    SeekPartyEngine
        .new(self,
             params: params,
             white_list: white_list,
             black_list: black_list,
             scopes: scopes)
        .search
  end
end