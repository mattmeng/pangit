require 'pangit/models/rooms'

describe Pangit::Models::Rooms do
  before( :each ) do
    Pangit::DataStore.instance.instance_variable_set( :@store, {} )
    Pangit::Models::Rooms.register
  end

  let( :id ) { :test }
  let( :name ) { 'Matt Meng' }
  let( :rooms ) { Pangit::Models::Rooms }

  describe '.add_room' do
    let( :room_id_already_exists ) { Pangit::Exceptions::RoomIDAlreadyExists }

    it( 'errors if an id already exists' ) do
      rooms.add_room( id, name )
      expect { rooms.add_room( id, name ) }.to raise_error( room_id_already_exists )
    end
  end

  describe '[]' do
    it( 'returns nil if no value exists' ) { expect( rooms[name] ).to be_nil }
    it( 'returns value' ) do
      rooms.add_room( id, name )
      expect( rooms[id] ).not_to be_nil
    end
  end
end

describe Pangit::Models::Room do
  let( :id ) { :test }
  let( :name ) { 'test' }
  let( :room ) { Pangit::Models::Room }
  let( :user ) { :user }
  let( :test_room ) { room.new( id, name ) }

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

  describe '.add_user' do
    let( :existing_user ) { :existing_user }
    let( :invalid_user ) { 'test' }
    let( :room_invalid_user ) { Pangit::Exceptions::RoomInvalidUser }

    it( 'adds a new user' ) do
      test_room.add_user( user )
      expect( test_room.users.select {|v| v == user}.count ).to be( 1 )
    end
    it( 'errors on invalid user' ) { expect { test_room.add_user( invalid_user ) }.to raise_error( room_invalid_user ) }
    it( "doesn't add existing user" ) do
      test_room.add_user( existing_user )
      test_room.add_user( existing_user )
      expect( test_room.users.select {|v| v == existing_user}.count ).to be( 1 )
    end
  end

  describe '.remove_user' do
    it( 'removes a user' ) do
      test_room.add_user( user )
      expect( test_room.users.select {|v| v == user}.count ).to be( 1 )
      test_room.remove_user( user )
      expect( test_room.users.select {|v| v == user}.count ).to be( 0 )
    end
  end
end