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
    return if @queries.blank?

    @queries.map { |key, value|
      if key == @queries.keys.first
        value
      else
        or_and(value)
      end }.sum
  end

  def or_and(value)
    @params[:search].present? ? " OR #{value}" : " AND #{value}"
  end
end