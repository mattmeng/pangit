require 'pangit/exceptions'
require 'pangit/data_store'

module Pangit
  module Models
    # class CardSets
    #   STORE = Pangit::DataStore.instance
    #   STORE_KEY = :card_sets

    #   def self.register
    #     STORE.add_store( STORE_KEY, {} )
    #   end

    #   def self.add_card_set( name, session_id )
    #     raise Exceptions::UserSessionIDAlreadyExists if STORE[STORE_KEY].has_key?( session_id )
    #     return STORE[STORE_KEY][session_id] = User.new( name, session_id )
    #   end

    #   def self.remove_user( id )
    #     STORE[STORE_KEY][id].rooms.each {|room| Rooms[room].remove_user( id )}
    #     return STORE[STORE_KEY].delete( id )
    #   end

    #   def self.[]( key )
    #     return STORE[STORE_KEY][key]
    #   end

    #   def self.exists?( key )
    #     return STORE[STORE_KEY].has_key?( key )
    #   end
    # end

    class CardSet
      attr_reader :id
      attr_reader :name
      attr_reader :cards

      def initialize( id, name, cards )
        raise Exceptions::CardSetIDInvalid unless id.is_a? Symbol
        @id = id
        self.name = name
        self.cards = cards
      end

      def name=( name )
        raise Exceptions::CardSetNameInvalid unless name =~ /^[A-Za-z0-9\s.,_-]+$/ and name.strip! != ''
        @name = name
      end

      def cards=( cards )
        raise Exceptions::CardSetInvalidType unless cards.is_a? Hash
        cards.each do |key, value|
          raise Exceptions::CardSetInvalidIDType unless key.is_a? Symbol
          raise Exceptions::CardSetInvalidNameType unless value.is_a? String
        end
        @cards = cards
      end

      def valid?( card )
        return @cards.include?( card )
      end

      # def add_room( room_id, add_me_to_room = true )
      #   raise Exceptions::RoomIDInvalid unless Rooms.exists?( room_id )
      #   unless @rooms.include?( room_id )
      #     @rooms << room_id
      #     Rooms[room_id].add_user( @id, false ) if add_me_to_room
      #   end
      # end

      # def remove_room( room )
      #   @rooms.delete( room )
      # end
    end
  end
end

# Pangit::Models::Users.register