require 'pangit/models/rooms'
require 'pangit/models/users'
require 'pangit/models/card_sets'

describe Pangit::Models::Rooms do
  let( :id ) { :test }
  let( :name ) { 'Matt Meng' }
  let( :rooms ) { Pangit::Models::Rooms }

  before( :each ) do
    Pangit::DataStore.instance.instance_variable_set( :@store, {} )
    Pangit::Models::Rooms.register
    Pangit::Models::Users.register
  end

  describe '.add_room' do
    let( :existing_room ) { :existing_room }
    let( :room_id_already_exists ) { Pangit::Exceptions::RoomIDAlreadyExists }

    it( 'adds a room' ) do
      expect( rooms.add_room( id, name ) ).to be_a( Pangit::Models::Room )
      expect( rooms[id] ).not_to be_nil
    end
    it( 'errors if an id already exists' ) do
      rooms.add_room( existing_room, existing_room.to_s )
      expect { rooms.add_room( existing_room, existing_room.to_s ) }.to raise_error( room_id_already_exists )
    end
  end

  describe '.remove_room' do
    let( :user1 ) { 'user1' }
    let( :user2 ) { 'user2' }
    let( :users ) { Pangit::Models::Users }
    it( 'removes a room from Rooms and all users' ) do
      test_room = rooms.add_room( id, name )
      test_user1 = users.add_user( user1, user1 )
      test_user2 = users.add_user( user2, user2 )
      test_user1.add_room( id )
      test_user2.add_room( id )

      expect( test_user1.rooms ).to include( id )
      expect( test_user2.rooms ).to include( id )

      rooms.remove_room( id )
      expect( test_user1.rooms ).not_to include( id )
      expect( test_user2.rooms ).not_to include( id )
      expect( rooms[id] ).to be_nil
    end
  end

  def self.remove_room( id )
        STORE[STORE_KEY][id].users.each {|user| user.remove_room( id )}
        return STORE[STORE_KEY].delete( id )
      end

  describe '[]' do
    it( 'returns nil if no value exists' ) { expect( rooms[name] ).to be_nil }
    it( 'returns value' ) do
      rooms.add_room( id, name )
      expect( rooms[id] ).not_to be_nil
    end
  end

  describe '.exists?' do
    let( :no_id ) { :no_id }

    it( 'returns false if none' ) { expect( rooms.exists?( no_id ) ).to be( false ) }
    it( 'returns true if found' ) do
      rooms.add_room( no_id, no_id.to_s )
      expect( rooms.exists?( no_id ) ).to be( true )
    end
  end
end

describe Pangit::Models::Room do
  let( :id ) { :test }
  let( :name ) { 'test' }
  let( :user_name ) { 'user' }
  let( :room ) { Pangit::Models::Room }
  let( :test_room ) do
    return Pangit::Models::Rooms[id]
  end
  let( :users ) { Pangit::Models::Users }

  before( :each ) do
    Pangit::DataStore.instance.instance_variable_set( :@store, {} )
    Pangit::Models::Rooms.register
    Pangit::Models::Users.register
    Pangit::Models::CardSets.register
    Pangit::Models::Rooms.add_room( id, name )
  end

  describe '#id' do
    let( :id_nil ) { nil }
    let( :id_number ) { 4 }
    let( :id_blank ) { ' ' }
    let( :room_id_invalid_exc ) { Pangit::Exceptions::RoomIDInvalid }

    it( 'has an id' ) { expect( test_room.id ).to eq( id ) }
    it( 'errors on invalid session_id' ) do
      expect { room.new( id_nil, name ) }.to raise_error( room_id_invalid_exc )
      expect { room.new( id_number, name ) }.to raise_error( room_id_invalid_exc )
      expect { room.new( id_blank, name ) }.to raise_error( room_id_invalid_exc )
    end
  end

  describe '#name' do
    let( :name_nil ) { nil }
    let( :name_number ) { 4 }
    let( :name_blank ) { ' ' }
    let( :room_name_invalid_exc ) { Pangit::Exceptions::RoomNameInvalid }

    it( 'has a name' ) { expect( test_room.name ).to eq( name ) }
    it( 'errors on invalid name' ) do
      expect { room.new( id, name_nil ) }.to raise_error( room_name_invalid_exc )
      expect { room.new( id, name_number ) }.to raise_error( room_name_invalid_exc )
      expect { room.new( id, name_blank ) }.to raise_error( room_name_invalid_exc )
      expect { test_room.name = name_nil }.to raise_error( room_name_invalid_exc )
      expect { test_room.name = name_number }.to raise_error( room_name_invalid_exc )
      expect { test_room.name = name_blank }.to raise_error( room_name_invalid_exc )
    end
  end

  describe '#card_set' do
    let( :card_sets ) { Pangit::Models::CardSets }
    let( :card_set_id ) { :fibonacci }
    let( :card_set_name ) { 'Fibonacci' }
    let( :card_set_cards ) { {x: 'x', y: 'y', z: 'z'} }
    let( :card_set_id_invalid ) { Pangit::Exceptions::CardSetIDInvalid }

    it( 'sets a valid card set' ) do
      card_set = card_sets.add_card_set( card_set_id, card_set_name, card_set_cards )
      test_room.card_set = card_set_id
      expect( test_room.card_set ).to eq( card_set_id )
    end

    it( 'errors on invalid card set' ) do
      expect { test_room.card_set = card_set_id.to_s }.to raise_error( card_set_id_invalid )
    end
  end

  describe '#choices' do
    it( 'has choices' ) { expect( test_room.choices ).to be_a( Hash ) }
  end

  describe '.add_user' do
    let( :existing_user ) { 'existing_user' }
    let( :invalid_user ) { :invalid_user }
    let( :user_invalid ) { Pangit::Exceptions::UserInvalid }

    it( 'adds a new user' ) do
      users.add_user( user_name, user_name )
      test_room.add_user( user_name )
      expect( test_room.users.select {|v| v == user_name}.count ).to be( 1 )
      expect( users[user_name].rooms ).to include( id )
    end
    it( 'errors on invalid user' ) { expect { test_room.add_user( invalid_user ) }.to raise_error( user_invalid ) }
    it( "doesn't add existing user" ) do
      users.add_user( existing_user, existing_user )
      test_room.add_user( existing_user )
      test_room.add_user( existing_user )
      expect( test_room.users.select {|v| v == existing_user}.count ).to be( 1 )
    end
  end

  describe '.remove_user' do
    it( 'removes a user' ) do
      users.add_user( user_name, user_name )
      test_room.add_user( user_name )
      expect( test_room.users.select {|v| v == user_name}.count ).to be( 1 )
      test_room.remove_user( user_name )
      expect( test_room.users.select {|v| v == user_name}.count ).to be( 0 )
    end
  end

  describe '.choose_card' do
    let( :user_id ) { 'user_id' }
    let( :card_id ) { :card_id }
    let( :card_set ) { {card_id: 'card_id'} }
    let( :invalid_card_id ) { :invalid_card_id }
    let( :user_invalid ) { Pangit::Exceptions::UserInvalid }
    let( :card_invalid ) { Pangit::Exceptions::CardInvalid }

    it( 'errors on invalid user' ) do
      expect { test_room.choose_card( user_id, card_id ) }.to raise_error( user_invalid )
      Pangit::Models::Users.add_user( user_id, user_id )
      expect { test_room.choose_card( user_id, card_id ) }.to raise_error( user_invalid )
    end
    it( 'errors on invalid card' ) do
      Pangit::Models::Users.add_user( user_id, user_id )
      test_room.add_user( user_id )
      expect { test_room.choose_card( user_id, card_id ) }.to raise_error( card_invalid )
      Pangit::Models::CardSets.add_card_set( card_id, card_id.to_s, card_set )
      test_room.card_set = card_id
      expect { test_room.choose_card( user_id, invalid_card_id ) }.to raise_error( card_invalid )
    end
    it( 'chooses a valid card for a valid user' ) do
      Pangit::Models::Users.add_user( user_id, user_id )
      test_room.add_user( user_id )
      Pangit::Models::CardSets.add_card_set( card_id, card_id.to_s, card_set )
      test_room.card_set = card_id
      test_room.choose_card( user_id, card_id )
      expect( test_room.choices[user_id] ).to be( card_id )
    end
  end

  describe '.clear_choices' do
    let( :user_id ) { 'user_id' }
    let( :card_id ) { :card_id }
    let( :card_set ) { {card_id: 'card_id'} }

    it( 'clears all choices' ) do
      Pangit::Models::Users.add_user( user_id, user_id )
      test_room.add_user( user_id )
      Pangit::Models::CardSets.add_card_set( card_id, card_id.to_s, card_set )
      test_room.card_set = card_id
      test_room.choose_card( user_id, card_id )
      expect( test_room.choices[user_id] ).to be( card_id )
      test_room.clear_choices()
      expect( test_room.choices ).to be_empty
    end
  end
end