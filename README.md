# Datastractor

A gem to manage API interactions between data sources you want to extract data from and data targets you want to push that data into.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'datastractor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install datastractor

## Usage

    date_range = DateTime.parse("June 1 2017")..DateTime.parse("June 27 2017")
    maint_incidents = StatusPage.new.get_incidents(search: "maintenance", date_range: date_range, status: "completed")

    puts "Number of maintenance incidents: #{maint_incidents.size}"
    puts "Maintenance count by application/component:"
    incident_data_by_component(maint_incidents).each_pair {|component, data| puts "\t#{component} => count: #{data[:count]}\tduration: #{data[:duration]}"}
    puts "Total time in maintenance(minutes): #{(total_incident_duration(maint_incidents)/60).round}"

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aaa-ncnu-ie/datastractor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

