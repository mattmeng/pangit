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

  # class Room
  #   attr_reader :name
  #   attr_reader :users

  #   def initialize( name )
  #     @name = name
  #     @config = {}
  #     @users = []
  #   end

  #   def name=( name )
  #     raise Exceptions::RoomNameInvalid unless name and name.strip != ''
  #     @name = name
  #   end

  #   def []( key )
  #     return @config[key]
  #   end

  #   def []=( key, value )
  #     @config[key] = value
  #   end

  #   def user_exists?( name )
  #     return @users.select {|v| v == name}.count > 0
  #   end

  #   def add_user( user )
  #     raise Exceptions::RoomInvalidUser unless user.class == Symbol
  #     raise Exceptions::RoomUserAlreadyExists if user_exists?( user )
  #     @users << user
  #   end

  #   def remove_user( user )
  #     @users.delete( user )
  #   end
  # end
end