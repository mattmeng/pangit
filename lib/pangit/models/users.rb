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
        STORE[STORE_KEY][session_id] = User.new( name, session_id )
        return session_id
      end

      def self.[]( key )
        return STORE[STORE_KEY][key]
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

      def add_room( room_id )
        raise Exceptions::RoomIDInvalid unless Rooms
      end
    end
  end
end

Pangit::Models::Users.register