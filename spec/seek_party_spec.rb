require_relative './../lib/seek_party'
require_relative 'active_record_helper'
require_relative 'models/application_record'
require_relative 'models/user'

User.create(name: 'Charles Aquino', email: 'charles@somewhere.com')
User.create(name: 'Charles Wellington', email: 'c.wellington@somewhere.com')
User.create(name: 'Bilbo Baggins', email: 'bilbo@theshire.com')

RSpec.describe SeekParty do
  it 'has a version number' do
    expect(SeekParty::VERSION).not_to be nil
  end

  context 'when using it correctly' do
    it '#search for bilbo should return one result' do
      params = {search: 'bilbo'}
      expect(User.search(params: params).count).to eq(1)
    end

    it '#search for Aquino with chained scope should return one result' do
      params = {search: 'Aquino'}
      result = User
                   .search(params: params)
                   .insanely_specific_and_useless_scope('charles@somewhere.com', 'Charles Aquino')
      expect(result.count).to eq(1)
    end

    it '#search for Aquino with email should return one result' do
      params = {search: 'Aquino', email: 'charles@somewhere.com'}
      result = User
                   .search(params: params)
                   .insanely_specific_and_useless_scope('charles@somewhere.com', 'Charles Aquino')
      expect(result.count).to eq(1)
    end
  end
end
