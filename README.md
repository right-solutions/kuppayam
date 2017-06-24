# Kuppayam

Kuppayam is a basic UI to starter kit.

A basic UI starter kit - rails engine with useful helpers and bootstrap based UI modules

## How to use Kuppayam?

just add kuppayam to gemfile and you are done.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kuppayam'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install kuppayam
```

## Contributing

Fork the project from the repository https://github.com/right-solutions/kuppayam

Make your changes & Send a Pull Request.

## Gem Release Instructions

```bash
$ gem build kuppayam.gemspec
```

```bash
$ gem push gem push kuppayam-0.1.1.gem
```


## Testing the gem

cd spec/dummy
rails db:create db:migrate

rails s -p <port>

## Running rspec
rails db:create db:migrate RAILS_ENV

# run rspec from the rails root folder and not from dummy folder as spec helper has been linked to dummy.
rspec 


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).



