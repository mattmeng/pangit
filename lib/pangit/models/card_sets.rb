require 'pangit/exceptions'
require 'pangit/data_store'

module Pangit
  module Models
    class CardSets
      STORE = Pangit::DataStore.instance
      STORE_KEY = :card_sets

      def self.register
        STORE.add_store( STORE_KEY, {} )
      end

      def self.add_card_set( id, name, cards )
        raise Exceptions::CardSetIDAlreadyExists if STORE[STORE_KEY].has_key?( id )
        return STORE[STORE_KEY][id] = CardSet.new( id, name, cards )
      end

      def self.[]( key )
        return STORE[STORE_KEY][key]
      end

      def self.exists?( key )
        return STORE[STORE_KEY].has_key?( key )
      end
    end

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
    end
  end
end

Pangit::Models::CardSets.register