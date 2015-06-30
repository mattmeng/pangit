require 'pangit/models/users'
require 'pangit/models/rooms'

describe Pangit::Models::Users do
  let( :name ) { 'Matt Meng' }
  let( :session_id ) { '4' }
  let( :users ) { Pangit::Models::Users }

  before( :each ) do
    Pangit::DataStore.instance.instance_variable_set( :@store, {} )
    Pangit::Models::Users.register
    Pangit::Models::Rooms.register
  end

  describe '.add_user' do
    let( :user_session_id_already_exists ) { Pangit::Exceptions::UserSessionIDAlreadyExists }

    it( 'errors if a session id already exists' ) do
      users.add_user( name, session_id )
      expect { users.add_user( name, session_id ) }.to raise_error( user_session_id_already_exists )
    end
  end

  describe '.remove_user' do
    let( :room1 ) { :user1 }
    let( :room2 ) { :user2 }
    let( :rooms ) { Pangit::Models::Rooms }
    it( 'removes a user from Users and all rooms' ) do
      test_user = users.add_user( name, session_id )
      test_room1 = rooms.add_room( room1, room1.to_s )
      test_room2 = rooms.add_room( room2, room2.to_s )
      test_room1.add_user( session_id )
      test_room2.add_user( session_id )

      expect( test_room1.users ).to include( session_id )
      expect( test_room2.users ).to include( session_id )

      users.remove_user( session_id )
      expect( test_room1.users ).not_to include( session_id )
      expect( test_room2.users ).not_to include( session_id )
      expect( users[session_id] ).to be_nil
    end
  end

  describe '[]' do
    it( 'returns nil if no value exists' ) { expect( users[name] ).to be_nil }
    it( 'returns value' ) do
      users.add_user( name, session_id )
      expect( users[session_id] ).not_to be_nil
    end
  end

  describe '.exists?' do
    let( :no_id ) { 'no_id' }
    it( 'returns false if none' ) { expect( users.exists?( no_id ) ).to be( false ) }
    it( 'returns true if found' ) do
      users.add_user( no_id, no_id )
      expect( users.exists?( no_id ) ).to be( true )
    end
  end
end

describe Pangit::Models::User do
  let( :name ) { 'test' }
  let( :session_id ) { '4' }
  let( :user ) { Pangit::Models::User }
  let( :test_user ) do
    return Pangit::Models::Users[session_id]
  end
  let( :rooms ) { Pangit::Models::Rooms }

  before( :each ) do
    Pangit::DataStore.instance.instance_variable_set( :@store, {} )
    Pangit::Models::Users.register
    Pangit::Models::Rooms.register
    Pangit::Models::Users.add_user( name, session_id )
  end

  describe '#id' do
    let( :session_id_nil ) { nil }
    let( :session_id_number ) { 4 }
    let( :session_id_blank ) { ' ' }
    let( :session_id_invalid_exc ) { Pangit::Exceptions::UserSessionIDInvalid }

    it( 'has an id' ) { expect( test_user.id ).to eq( session_id ) }
    it( 'errors on invalid session_id' ) do
      expect { user.new( name, session_id_nil ) }.to raise_error( session_id_invalid_exc )
      expect { user.new( name, session_id_number ) }.to raise_error( session_id_invalid_exc )
      expect { user.new( name, session_id_blank ) }.to raise_error( session_id_invalid_exc )
    end
  end

  describe '#name' do
    let( :name_nil ) { nil }
    let( :name_number ) { 4 }
    let( :name_blank ) { ' ' }
    let( :user_invalid_exc ) { Pangit::Exceptions::UserNameInvalid }

    it( 'has a name' ) { expect( test_user.name ).to eq( name ) }
    it( 'errors on invalid name' ) do
      expect { user.new( name_nil, session_id ) }.to raise_error( user_invalid_exc )
      expect { user.new( name_number, session_id ) }.to raise_error( user_invalid_exc )
      expect { user.new( name_blank, session_id ) }.to raise_error( user_invalid_exc )
      expect { test_user.name = name_nil }.to raise_error( user_invalid_exc )
      expect { test_user.name = name_number }.to raise_error( user_invalid_exc )
      expect { test_user.name = name_blank }.to raise_error( user_invalid_exc )
    end
  end

  describe '#rooms' do
    it( 'has rooms that is an Array' ) { expect( test_user.rooms ).to be_a( Array ) }
  end

  describe '.add_room' do
    let( :room_id ) { :test }
    let( :existing_room ) { :existing_room }
    let( :invalid_room ) { 'invalid_room' }
    let( :room_id_invalid ) { Pangit::Exceptions::RoomIDInvalid }

    it( 'adds a new room' ) do
      rooms.add_room( room_id, room_id.to_s )
      test_user.add_room( room_id )
      expect( test_user.rooms.select {|v| v == room_id}.count ).to be( 1 )
      expect( rooms[room_id].users ).to include( session_id )
    end
    it( 'errors on invalid room' ) { expect { test_user.add_room( invalid_room ) }.to raise_error( room_id_invalid ) }
    it( "doesn't add existing room" ) do
      rooms.add_room( existing_room, existing_room.to_s )
      test_user.add_room( existing_room )
      test_user.add_room( existing_room )
      expect( test_user.rooms.select {|v| v == existing_room}.count ).to be( 1 )
    end
  end
end