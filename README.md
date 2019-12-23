# SeekParty - Searches made easy

[![Build Status](https://travis-ci.org/caws/seek_party.svg?branch=master)](https://travis-ci.org/caws/seek_party)
[![Maintainability](https://api.codeclimate.com/v1/badges/a05e479c6f535645d307/maintainability)](https://codeclimate.com/github/caws/seek_party/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a05e479c6f535645d307/test_coverage)](https://codeclimate.com/github/caws/seek_party/test_coverage)

### What is this?

Have you ever had to write a search functionality for a web application and found yourself
having to write SQL code? 

**Then this is for you.** 

SeekParty adds the method #search to classes that extend it. Once called, SeekParty builds and runs those ugly SQL
queries in a nice way by inspecting your attributes and checking what is present in your params hash
against the attributes of your model.

Since it returns an instance of ActiveRecord_Relation, you can chain other scopes/methods if you
so desire.   

Currently compatible with Sqlite3 and PostgreSQL.

### When should I use this?

When coming up with simple search features for a given application. 

### What is this capable of doing?

Below is what's currently doable:
  - Search for specific attributes (by passing a params hash where the key is your attribute name and 
    the value is what you're looking for).
  - Hit the database with a query containing LIKE for all attributes not present in the BLACK_LIST (or present in the WHITE_LIST) and using
    a value stored in your params[:search] key. 
  - Hit the database with a query containing LIKE and the operator = for all attributes not present in the BLACK_LIST (or present in the WHITE_LIST) 
    and using a value stored in your params[:search] key and a key for one of your attributes (params[:name], for the example of a class User).     

PS: The DEFAULT_BLACK_LIST contains the attributes :id, :created_at and :updated_at. You can pass your own
    DEFAULT_BLACK_LIST when calling the #search method from your model, but I recommend using the WHITE_LIST, 
    as SeekParty will then only generate queries using the column names present there.
    You should also keep in mind that when building the queries, seek_party tries to pluralize your table name in order to refer to the table
    columns by their full name (ex: 'your_table.your_column_name').

## Getting started

### Instalation

Add the following to your Gemfile

``` ruby
gem 'seek_party', '~> 0.0.3'
```
Then run:

``` shell
bundle install
```

Add the SeekParty functionality to your model:

``` ruby
class User < ApplicationRecord
  extend SeekParty
  ...
end
```

## Usage

Given a User model like the following:

``` ruby
  create_table :users, force: true do |t|
    t.string :name
    t.string :email
  end
```

You could search the table like so:

``` ruby
params = {search: 'bilbo'}
User.search(params: params)
```

PS: The params hash can be either created by you or you can pass the ActionController::Parameters
instance that is available at the controller level.

And it would produce the following query for Sqlite3:

``` sql
SELECT "users".* FROM "users" WHERE (LOWER(CAST(users.name AS TEXT)) LIKE '%bilbo%' OR LOWER(CAST(users.email AS TEXT)) LIKE '%bilbo%')
```

As you can see, it took all of the attributes into consideration when generating the
query. But you can also limit what's going to be used to build such query by writing it 
in the following way:

``` ruby
params = {search: 'bilbo'}
User.search(params: params, white_list: ['name'])
```

Which would in turn produce the following query:

``` sql
SELECT "users".* FROM "users" WHERE (LOWER(CAST(users.name AS TEXT)) LIKE '%bilbo%')
```

If your params hash does not contain a search key, SeekParty will try to compare
the attributes in your model with the keys available in the params hash.

Which means that the following:

``` ruby
params = {name: 'bilbo'}
User.search(params: params)
```

Would produce a query like this:
``` sql
SELECT "users".* FROM "users" WHERE (LOWER(CAST(users.name AS TEXT)) = 'bilbo')
```

SeekParty would use the equals operator instead of the LIKE, since it infers that
if you have keys in your params hash that match the attributes in your model, you basically 
know what you are looking for.

But say that you are searching for a record for which you know one of the attributes for SURE, 
but not the other(s). In this case, you could use both the search key as well as one key for 
each one of your attributes like this:


``` ruby
params = {search: 'bilbo@theshire.com', name: 'bilbo'}
User.search(params: params)
```

And this would result in the following query being produced:

``` sql
SELECT "users".* FROM "users" WHERE (LOWER(CAST(users.name AS TEXT)) LIKE '%sugoi%' AND LOWER(CAST(users.name AS TEXT)) = 'bilbo' OR LOWER(CAST(users.email AS TEXT)) LIKE '%sugoi%' AND LOWER(CAST(users.name AS TEXT)) = 'bilbo')
```

### TO DO

- Write more tests
- Improve code quality
- Add support to other adapters 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/caws/seek_party. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SeekParty project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/seek_party/blob/master/CODE_OF_CONDUCT.md).
