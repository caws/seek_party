class User < ApplicationRecord
  extend SearchParty

  scope :insanely_specific_and_useless_scope, ->(email, name) {
    where(email: email, name: name)
  }
end