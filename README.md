# Moist::Action

[![Build Status](https://travis-ci.org/moist-rb/action.svg?branch=master)](https://travis-ci.org/moist-rb/action)
[![Test Coverage](https://api.codeclimate.com/v1/badges/368503b9d12c2c97e40f/test_coverage)](https://codeclimate.com/github/moist-rb/action/test_coverage)
[![Gem Version](https://badge.fury.io/rb/moist-action.svg)](https://badge.fury.io/rb/moist-action)

This module provides validation logic for controller actions. 
You can use it to replace strong params in Rails and simplify testing. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moist-action'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moist-action

## Usage

Each action should be extracted to separate class:

```ruby
class RegisterUser
  include Moist::Action
  
  params do
    required(:name).filled(:str?)
    required(:email).filled(format?: EMAIL_REGEX)
    required(:age).maybe(:int?)
  end

  def perform(params)
    User.create(params)
  end
end
```

You are free and strongly encouraged to use class constructor to inject buisenes logic.
The idiomatic way to use `Moist::Action` is to validate user input and call buisenes logic.

```ruby
class RegisterUser
  include Moist::Action
  
  def initialize(users_service:)
    @users_service = users_service   
  end
  
  params do
    required(:name).filled(:str?)
    required(:email).filled(format?: EMAIL_REGEX)
    required(:age).maybe(:int?)
  end

  def perform(params)
    @users_service.register(params)
  end
end
```

Method `perform` considered private and should never be called directly. Use `call` method 
instead. It validates user input and call `perform` passing filtered hash.

```ruby
action = RegisterUser.new(users_service: users_service)
action.(params)
```

Method `params` receive only three valid params (`name`, `email`, and `age`). Any additional
params will be stripped out. It doesn't call `perform` at all if params are invalid.  
`Moist::Action` uses [dry-validation](http://dry-rb.org/gems/dry-validation/) under the hood.

The result of evaluation of `call` method is either `Fear::Left` (with errors hash) in case of invalid params
or `Fear::Reght` (with result of evaluation of `perform` method) in case of valid params

```ruby
action.(email: 'CarlLazlo@example.com', age: 39) #=> Fear::Left({ name: ['must be filled'] }) 
action.(name: 'Carl Lazlo', email: 'CarlLazlo@example.com', age: 39) #=> Fear::Right(User)
```  

You can define what to do in case of validation success of failure:

```ruby
result = register.(params)
result.reduce(
  ->(errors) { render_unprocessable_entity(errors) },
  ->(user) { render_json(user) }
)
```
 
Either monad has rich api, see [docs](http://www.rubydoc.info/github/bolshakov/fear/master/Fear/Either) for details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moist-rb/action.

