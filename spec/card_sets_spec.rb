require 'pangit/models/card_sets'

describe Pangit::Models::CardSet do
  let( :card ) { Pangit::Models::CardSet }
  let( :test_card ) { card.new }

  before( :each ) do
    Pangit::DataStore.instance.instance_variable_set( :@store, {} )
    # Pangit::Models::Rooms.register
    # Pangit::Models::Users.register
  end

  describe '#cards' do
    let( :valid_cards ) { {x: 'a', y: 'b', z: 'c'} }
    let( :invalid_card_type ) { 'string' }
    let( :invalid_id_type )   { {'string' => 'string'} }
    let( :invalid_name_type ) { {test: :test} }
    let( :card_set_invalid_type ) { Pangit::Exceptions::CardSetInvalidType }
    let( :card_set_invalid_id_type ) { Pangit::Exceptions::CardSetInvalidIDType }
    let( :card_set_invalid_name_type ) { Pangit::Exceptions::CardSetInvalidNameType }

    it( 'exists on creation' ) { expect( card.new ).not_to be_nil }
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
end
