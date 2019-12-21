require_relative './../lib/search_party'
require_relative 'active_record_helper'
require_relative 'models/application_record'
require_relative 'models/user'

User.create(name: 'Charles Aquino', email: 'charles@somewhere.com')
User.create(name: 'Charles Wellington', email: 'c.wellington@somewhere.com')
User.create(name: 'Bilbo Baggins', email: 'bilbo@theshire.com')

RSpec.describe SearchParty do
  it "has a version number" do
    expect(SearchParty::VERSION).not_to be nil
  end

  context 'when using it correctly' do
    it '#search for bilbo should return one result' do
      params = {search: 'bilbo'}
      expect(User.search(params: params).count).to eq(1)
    end
  end
end
