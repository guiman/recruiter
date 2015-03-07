# Recruiter

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'recruiter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install recruiter

## Usage

Remember to set GITHUB_ACCESS_TOKEN env variable to increase API threshold limit

```
candidates = Recruiter.search.at("Portsmouth").and_at("Southampton").with_repos('>5').all

candidates.first.email
candidates.first.location
candidates.first.fullname
candidates.first.repository_count
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/recruiter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
