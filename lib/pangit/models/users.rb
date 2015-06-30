require 'pangit/exceptions'
require 'pangit/data_store'
require 'pangit/models/rooms'

module Pangit
  module Models
    class Users
      STORE = Pangit::DataStore.instance
      STORE_KEY = :users

      def self.register
        STORE.add_store( STORE_KEY, {} )
      end

      def self.add_user( name, session_id )
        raise Exceptions::UserSessionIDAlreadyExists if STORE[STORE_KEY].has_key?( session_id )
        return STORE[STORE_KEY][session_id] = User.new( name, session_id )
      end

      def self.remove_user( id )
        STORE[STORE_KEY][id].rooms.each {|room| Rooms[room].remove_user( id )}
        return STORE[STORE_KEY].delete( id )
      end

      def self.[]( key )
        return STORE[STORE_KEY][key]
      end

      def self.exists?( key )
        return STORE[STORE_KEY].has_key?( key )
      end
    end

    class User
      attr_reader :id   # Session ID
      attr_reader :name
      attr_reader :rooms

      def initialize( name, session_id )
        raise Exceptions::UserSessionIDInvalid unless session_id.is_a? String and session_id.strip != ''
        @id = session_id
        self.name = name
        @rooms = []
      end

      def name=( name )
        raise Exceptions::UserNameInvalid unless name =~ /^[A-Za-z0-9\s.,_-]+$/ and name.strip! != ''
        @name = name
      end

      def add_room( room_id, add_me_to_room = true )
        raise Exceptions::RoomIDInvalid unless Rooms.exists?( room_id )
        unless @rooms.include?( room_id )
          @rooms << room_id
          Rooms[room_id].add_user( @id, false ) if add_me_to_room
        end
      end

      def remove_room( room )
        @rooms.delete( room )
      end
    end
  end
end

Pangit::Models::Users.register