require 'pangit/exceptions'

module Pangit
  class DataStore
    def initialize
      @store = {}
    end

    def self.instance
      return @@instance ||= DataStore.new
    end

    def add_store( key, store )
      raise Exceptions::DataStoreInvalidKey unless key.is_a? Symbol
      raise Exceptions::DataStoreInvalidStore unless store.is_a? Array or store.is_a? Hash
      raise Exceptions::DataStoreAlreadyExists if @store.has_key?( key )
      @store[key] = store
      return key
    end

    def []( key )
      return @store[key]
    end
  end
end