class User < ApplicationRecord
  extend SeekParty

  scope :insanely_specific_and_useless_scope, ->(email, name) {
    where(email: email, name: name)
  }
end