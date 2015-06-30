require 'pangit/exceptions'
require 'pangit/data_store'

module Pangit
  module Models
    class Rooms
      STORE = Pangit::DataStore.instance
      STORE_KEY = :rooms

      def self.register
        STORE.add_store( STORE_KEY, {} )
      end

      def self.add_room( id, name )
        raise Exceptions::RoomIDAlreadyExists if STORE[STORE_KEY].has_key?( id )
        STORE[STORE_KEY][id] = Room.new( id, name )
        return id
      end

      def self.[]( key )
        return STORE[STORE_KEY][key]
      end

      def self.exists?( key )
        return STORE[STORE_KEY].has_key?( key )
      end
    end

    class Room
      attr_reader :id
      attr_reader :name
      attr_reader :users

      def initialize( id, name )
        raise Exceptions::RoomIDInvalid unless id.is_a? Symbol
        @id = id
        self.name = name
        @users = []
      end

      def name=( name )
        raise Exceptions::RoomNameInvalid unless name =~ /^[A-Za-z0-9\s.,_-]+$/ and name.strip! != ''
        @name = name
      end

      def add_user( user )
        raise Exceptions::RoomInvalidUser unless user.class == Symbol
        @users << user unless users.include?( user )
      end

      def remove_user( user )
        @users.delete( user )
      end
    end
  end
end

Pangit::Models::Rooms.register
