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
Recruiter.search
	.at("Portsmouth")
	.and_at("Southampton")
	.with_repos('>5')
	.skills("Ruby,Javascript")
	.all

candidate = _.first

candidate.email
candidate.location
candidate.fullname
candidate.repository_count
candidate.languages
candidate.skills
```


## Caching requests

When searching we can make sure our results are cached to prevent exceding the
Github API limit and also make response time shorter.

Introducing `Recruiter.search(search_strategy: Recruiter::CachedSearchStrategy)`.

It will behave the same way as the normal search but with the improvement that
results will be cached into a redis server.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/recruiter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
