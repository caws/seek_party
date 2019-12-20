require_relative './../lib/search_party'
require_relative 'active_record_helper'
require_relative 'models/application_record'

RSpec.describe SearchParty do
  it "has a version number" do
    expect(SearchParty::VERSION).not_to be nil
  end
end
