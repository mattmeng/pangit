require 'pangit/exceptions'

module Pangit
  class DataStore
    attr_reader :rooms
    attr_reader :users

    def initialize
      @config = {}
      @rooms = {}
      @users = {}
    end

    def self.instance
      return @@instance ||= DataStore.new
    end

    def add_room( name )
      raise Exceptions::DSRoomAlreadyExists if @rooms.has_key?( name.to_sym )
      @rooms[name.to_sym] = Room.new( name )
    end

    def remove_room( name )
      @rooms.delete( name.to_sym )
    end

    def add_user( name, session_id, room )
      raise Exceptions::DSRoomDoesntExist unless @rooms.has_key( room.to_sym )
      raise Exceptions::DSUserAlreadyExists if @users.has_key( name.to_sym )
      @users[name.to_sym] = User.new( name, session_id )
    end
  end

  class User
    attr_reader :id    # Session ID
    attr_reader :name

    def initialize( name, session_id )
      self.name = name
      self.session_id = session_id
    end

    def name=( name )
      raise Exceptions::UserNameInvalid unless name and name.strip != ''
      @name = name
    end

    def session_id=( session_id )
      raise Exceptions::UserSessionIDInvalid unless session_id and session_id.strip != ''
      @session_id = session_id
    end
  end

  class Room
    attr_reader :name
    attr_reader :users

    def initialize( name )
      @name = name
      @config = {}
      @users = []
    end

    def name=( name )
      raise Exceptions::RoomNameInvalid unless name and name.strip != ''
      @name = name
    end

    def []( key )
      return @config[key]
    end

    def []=( key, value )
      @config[key] = value
    end

    def user_exists?( name )
      return @users.select {|v| v == name}.count > 0
    end

    def add_user( user )
      raise Exceptions::RoomInvalidUser unless user.class == Symbol
      raise Exceptions::RoomUserAlreadyExists if user_exists?( user )
      @users << user
    end

    def remove_user( user )
      @users.delete( user )
    end
  end
end