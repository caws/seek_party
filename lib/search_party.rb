# I have been thinking about writing a gem called search_party that deals with
# searches for a given model. Thought I could test something using this project
# as basis. These files will stay in the util folder for now.
#
# Don't know if I'll move forward with it, but it works for the current need.
module SearchParty
  DEFAULT_BLACK_LIST = %w[id created_at updated_at].freeze

  # Method below triggers all the magic
  def search(params: [], black_list: DEFAULT_BLACK_LIST, white_list: nil)
    # If there are params to work with, use SearchParty.
    # Otherwise, just return the Class itself.
    if params.nil?
      self
    else
      params = params.permit(params.keys).to_h
      SearchPartyEngine
          .new(params,
               self,
               white_list: white_list,
               black_list: black_list)
          .search
    end
  end
end