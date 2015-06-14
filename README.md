# Recruiter

A gem designed to find potential candidates using Github's API.

## Dependecies

### Installing redis
```
$ brew install redis
```

### Starting redis server
```
$ redis-server
```

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
search = Recruiter.search
search.at("Portsmouth")
search.and_at("Southampton")
search.with_repos('>5')
search.skills("Ruby,Javascript")
candidates = search.all

candidate = candidates.first

candidate.email
candidate.avatar_url
candidate.location
candidate.name
candidate.repository_count
candidate.languages
candidate.skills
candidate.hireable
candidate.activity # all activity from the last 3 months
candidate.contributions # contributions to all organizations it belongs to
```


## Caching techniques

When dealing with candidates, repositories and organizations we can make sure our results are cached to prevent exceding the Github API limit and also make response time shorter.

In order to use them, do the following:


```
require 'recruiter/cached_github_candidate'

client = Recruiter::API.build_client(configuration: { access_token: 'TOKEN' } );
candidate = Recruiter::GithubCandidate.new(client.user("guiman"), client);
redis_client = Redis.new(....)
caching_method = Recruiter::RedisCache.new(redis_client)
cached_candidate = Recruiter::CachedGithubCandidate.new(candidate, caching_method)
```

With a `cached_candidates` all related objects like `Recruiter::GithubOrganization` will get wrapped in their cached counterparts `Recruiter::CachedGithubOrganization`.

We require Redis to be installed locally and running in localhost on default port.

The general behaviour is, if we can't find the information in local cache, then try to fetch it from github, store it and return the response.

Also, if you don't want to start with a candidate, you can use any of the other caching classes individually. Results will always be the same, related objects wrapped in caching clases.


## Running tests gotchats
When running tests, please make sure redis-server is running and accessible through default setup in localhost. Test related to caching results will try to use it.

Also remember that if you are planning on using caching strategies, redis also needs to be running.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/recruiter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
