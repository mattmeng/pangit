require 'pangit/models/card_sets'

describe Pangit::Models::CardSet do
  let( :id ) { :test }
  let( :name ) { 'valid' }
  let( :card_set ) { {} }
  let( :valid_cards ) { {x: 'a', y: 'b', z: 'c'} }
  let( :card ) { Pangit::Models::CardSet }
  let( :test_card ) { card.new( id, name, card_set ) }

  before( :each ) do
    Pangit::DataStore.instance.instance_variable_set( :@store, {} )
    # Pangit::Models::Rooms.register
    # Pangit::Models::Users.register
  end

  describe '#name' do
    let( :new_name ) { name + '_new' }
    let( :name_nil ) { nil }
    let( :name_number ) { 4 }
    let( :name_blank ) { ' ' }
    let( :card_set_invalid ) { Pangit::Exceptions::CardSetNameInvalid }

    it( 'has a name' ) { expect( test_card.name ).to eq( name ) }
    it( 'errors on invalid name' ) do
      expect { card.new( id, name_nil, card_set ) }.to raise_error( card_set_invalid )
      expect { card.new( id, name_number, card_set ) }.to raise_error( card_set_invalid )
      expect { card.new( id, name_blank, card_set ) }.to raise_error( card_set_invalid )
      expect { test_card.name = name_nil }.to raise_error( card_set_invalid )
      expect { test_card.name = name_number }.to raise_error( card_set_invalid )
      expect { test_card.name = name_blank }.to raise_error( card_set_invalid )
    end
    it( 'sets a name' ) do
      test_card.name = new_name
      expect( test_card.name ).to eq( new_name )
    end
  end

  describe '#cards' do
    let( :invalid_card_type ) { 'string' }
    let( :invalid_id_type )   { {'string' => 'string'} }
    let( :invalid_name_type ) { {test: :test} }
    let( :card_set_invalid_type ) { Pangit::Exceptions::CardSetInvalidType }
    let( :card_set_invalid_id_type ) { Pangit::Exceptions::CardSetInvalidIDType }
    let( :card_set_invalid_name_type ) { Pangit::Exceptions::CardSetInvalidNameType }

    it( 'exists on creation' ) { expect( card.new( id, name, card_set ) ).not_to be_nil }
    it( 'errors on invalid types' ) do
      expect { test_card.cards = invalid_card_type }.to raise_error( card_set_invalid_type )
      expect { test_card.cards = invalid_id_type }.to raise_error( card_set_invalid_id_type )
      expect { test_card.cards = invalid_name_type }.to raise_error( card_set_invalid_name_type )
    end
    it( 'sets cards' ) do
      test_card.cards = valid_cards
      expect( test_card.cards ).to eq( valid_cards )
    end
  end

  describe '.valid?' do
    let( :valid_card_set ) { card.new( id, name, valid_cards ) }

    it( 'returns false on invalid card' ) { expect( valid_card_set.valid?( :m ) ).to be( false ) }
    it( 'returns true on valid card' ) { expect( valid_card_set.valid?( :z ) ).to be( true ) }
  end
end
