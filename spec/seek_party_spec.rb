require_relative './../lib/seek_party'
require_relative 'active_record_helper'
require_relative 'models/application_record'
require_relative 'models/user'

charles_aquino_user = User.create(name: 'Charles Aquino', email: 'charles@somewhere.com')
charles_w_user = User.create(name: 'Charles Wellington', email: 'c.wellington@somewhere.com')
bilbo_user = User.create(name: 'Bilbo Baggins', email: 'bilbo@theshire.com')

RSpec.describe SeekParty do
  it 'has a version number' do
    expect(SeekParty::VERSION).not_to be nil
  end

  context 'when using it correctly' do
    it '#search with empty parameters should return #all records' do
      params = {}
      result = User.search(params: params)
      expect(result.count).to eq(User.count)
    end

    it '#search for bilbo should return one result' do
      params = {search: 'bilbo'}
      result = User.search(params: params)
      expect(result.count).to eq(1)
      expect(result).to include(bilbo_user)
    end

    it '#search for Aquino with chained scope should return one result' do
      params = {search: 'Aquino'}
      result = User
                   .search(params: params)
                   .insanely_specific_and_useless_scope('charles@somewhere.com', 'Charles Aquino')
      expect(result.count).to eq(1)
      expect(result).to include(charles_aquino_user)
    end

    it '#search for Aquino with email should return one result' do
      params = {search: 'Aquino', email: 'charles@somewhere.com'}
      result = User
                   .search(params: params)
                   .insanely_specific_and_useless_scope('charles@somewhere.com', 'Charles Aquino')
      expect(result.count).to eq(1)
      expect(result).to include(charles_aquino_user)
    end
  end
end
