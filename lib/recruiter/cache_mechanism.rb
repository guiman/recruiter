module Recruiter
  module CacheMechanism
    def method_missing(name, *args)
      cache_key = name.to_s
      cache_key.concat "_#{args.join("_")}" if args.any?

      if !(elements = @caching_method.fetch(cache_key, cache_namespace)).nil?
        cached_elements = elements
      else
        elements = args.any? ? @composite.public_send(name, *args) : @composite.public_send(name)
        @caching_method.store(cache_key, elements, cache_namespace)
        cached_elements = elements
      end

      cached_elements
    end

    def respond_to_missing?(method_name, include_private = false)
      @composite.respond_to?(method_name) || super
    end
  end
end
