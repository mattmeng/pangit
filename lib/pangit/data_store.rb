require 'pangit/exceptions'

module Pangit
  class DataStore
    attr_reader :rooms

    def initialize
      @config = {}
      @rooms = {}
    end

    def self.instance
      return @@instance ||= DataStore.new
    end

    def room_exists?( name )
      return @rooms.select {|k,v| v.name == name}.count > 0
    end

    def add_room( name )
      raise Exceptions::DSRoomAlreadyExists if @rooms.has_key?( name )
      @rooms[name] = Room.new( name )
    end

    def remove_room( name )
      @rooms.delete( name )
    end
  end

  class User
    attr_reader :name
    attr_reader :session_id

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
      raise Exceptions::UserNameInvalid unless name and name.strip != ''
      @name = name
    end

    def []( key )
      return @config[key]
    end

    def []=( key, value )
      @config[key] = value
    end

    def user_exists?( name )
      return @users.select {|v| v.name == name}.count > 0
    end

    def add_user( user )
      raise Exceptions::RoomInvalidUser unless user.class == User
      raise Exceptions::RoomUserAlreadyExists if user_exists?( user.name )
      @users << user
    end

    def remove_user( user )
      @users.delete( user )
    end
  end
end