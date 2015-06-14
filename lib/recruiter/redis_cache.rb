require 'redis'

module Recruiter
  class RedisCache
    KEY_STORAGE="__cached_keys"

    def initialize(client=Redis.new)
      @client = client

      unless client.get(KEY_STORAGE)
        store(KEY_STORAGE, [])
      end
    end

    def fetch(key, namespace="")
      value = @client.get(generate_key(key, namespace))
      Marshal.load(value) if value
    end

    def remove(key, namespace="")
      @client.del(generate_key(key, namespace))
    end

    def store(key, value, namespace="")
      marshaled_value = Marshal.dump(value)
      key_name = generate_key(key, namespace)

      register_key(key) unless key == KEY_STORAGE

      @client.set(key_name, marshaled_value)
    end

    def remove_namespace(namespace)
      fetch(KEY_STORAGE).each { |key| remove(key, namespace) }
    end

    def generate_key(name, namespace="")
      if namespace.empty?
        name
      else
       "#{namespace}_#{name}"
      end
    end

    private

    def register_key(key)
      existing_keys = fetch(KEY_STORAGE) || []

      existing_keys << key unless existing_keys.include?(key)

      store(KEY_STORAGE, existing_keys)
    end
  end
end
