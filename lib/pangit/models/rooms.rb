require 'pangit/exceptions'
require 'pangit/data_store'
require 'pangit/models/users'
require 'pangit/models/card_sets'

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
        return STORE[STORE_KEY][id] = Room.new( id, name )
      end

      def self.remove_room( id )
        STORE[STORE_KEY][id].users.each {|user| Users[user].remove_room( id )}
        return STORE[STORE_KEY].delete( id )
      end

      def self.[]( id )
        return STORE[STORE_KEY][id]
      end

      def self.exists?( id )
        return STORE[STORE_KEY].has_key?( id )
      end
    end

    class Room
      attr_reader :id
      attr_reader :name
      attr_reader :users
      attr_reader :card_set

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

      def add_user( user_id, add_me_to_user = true )
        raise Exceptions::RoomInvalidUser unless Users.exists?( user_id )
        unless users.include?( user_id )
          @users << user_id
          Users[user_id].add_room( @id, false ) if add_me_to_user
        end
      end

      def remove_user( user )
        @users.delete( user )
      end

      def card_set=( card_set )
        raise Exceptions::CardSetIDInvalid unless CardSets.exists?( card_set )
        return @card_set = card_set
      end
    end
  end
end

Pangit::Models::Rooms.register
