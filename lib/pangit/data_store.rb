module Pangit
  class DataStore
    attr_reader :config
    attr_reader :users

    def initialize
      @config = {}
      @users = {}
    end

    def self.instance
      return @@instance ||= DataStore.new
    end

    # def add_user()
  end

  class User
    attr_accessor :name
    attr_accessor :session_id

    def initialize( name, session_id )
      @name = name
      @session_id = session_id
    end
  end
end