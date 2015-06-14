require 'recruiter/redis_cache'

describe Recruiter::RedisCache do
  it "retrieves a value from cache" do
    caching_method = described_class.new(Redis.new)
    caching_method.remove("test_key")
    caching_method.store("test_key", "It works")
    expect(caching_method.fetch("test_key")).to eq("It works")
  end

  it "stores a value into cache" do
    caching_method = described_class.new(Redis.new)
    caching_method.remove("test_key")
    expect(caching_method.store("test_key", "It works")).to eq("OK")
  end

  it "removes a value from cache" do
    caching_method = described_class.new(Redis.new)
    caching_method.store("test_key", "It works")
    caching_method.remove("test_key")
    expect(caching_method.fetch("test_key")).to be_nil
  end

  it "genertes a key without namespace" do
    caching_method = described_class.new(Redis.new)
    expect(caching_method.generate_key("new_key")).to eq("new_key")
  end

  it "genertes a key with namespace" do
    caching_method = described_class.new(Redis.new)
    expect(caching_method.generate_key("new_key", "funky_namespace")).to eq("funky_namespace_new_key")
  end

  it "removes all keys in a namespace" do
    caching_method = described_class.new(Redis.new)
    caching_method.store("test_key", "It works", "namespace")
    caching_method.store("test_key_2", "It works as well", "namespace")

    caching_method.remove_namespace("namespace")

    expect(caching_method.fetch("test_key", "namespace")).to be_nil
    expect(caching_method.fetch("test_key_2", "namespace")).to be_nil
  end
end
