class SPQuery
  attr_accessor :queries, :params

  def initialize(queries: {}, params: nil)
    @queries = queries
    @params = params
  end

  def add_attribute_query(attribute, query)
    @queries[attribute] << query
  end

  def set_attribute_query(attribute, query)
    @queries[attribute] = query
  end

  def build_final_query
    final_query = ''
    @queries.each do |_key, value|
      next unless value

      final_query << if value == @queries[@queries.keys.first]
                       value
                     else
                       @params[:search].present? ? " OR #{value}" : " AND #{value}"
                     end
    end

    final_query
  end

end