require 'spec_helper'
require 'pangit'

describe Pangit::DataStore do
  before( :all ) do
    @name = 'test'
  end

  let( :data_store ) { Pangit::DataStore.instance }

  it 'gives back the same instance' do
    expect( Pangit::DataStore.instance.object_id ).to eq( Pangit::DataStore.instance.object_id )
  end

  describe '.room_exists?' do
    it( 'can check if a room exists already' ) do
      test_name = @name + '_exists'
      data_store.add_room( test_name )
      expect( data_store.room_exists?( test_name ) ).to be( true )
    end

    it( 'can check if a user does not exist' ) do
      expect( data_store.room_exists?( @name + '_blah' ) ).to be( false )
    end
  end

  describe '.add_room' do
    it( 'adds a user' ) do
      data_store.add_room( @name )
      expect( data_store.rooms[@name] ).not_to eq( nil )
    end

    it( 'errors if room already exists' ) do
      test_name = @name + '_add'
      data_store.add_room( test_name )
      expect { data_store.add_room( test_name ) }.to raise_error( Pangit::Exceptions::DSRoomAlreadyExists )
    end

    # it( 'errors on invalid room name' ) { expect { data_store.add_user( user_name, session_id, '' ) }.to raise_error( Pangit::Exceptions::DSRoomDoesntExist ) }
  end

  describe '.remove_room' do
    it( 'can delete rooms' ) do
      test_name = @name + '_remove'
      data_store.add_room( test_name )
      expect( data_store.rooms.has_key?( test_name ) ).to be( true )
      data_store.remove_room( test_name )
      expect( data_store.rooms.include?( test_name ) ).to be( false )
    end
  end
end

describe Pangit::User do
  before do
    @name = 'test'
    @session_id = '4'
    @invalid_value_1 = nil
    @invalid_value_2 = ' '
  end

  let( :user ) { Pangit::User.new( @name, @session_id ) }
  let( :user_invalid_exc ) { Pangit::Exceptions::UserNameInvalid }
  let( :session_id_invalid_exc ) { Pangit::Exceptions::UserSessionIDInvalid }

  describe '#name' do
    it( 'has a name' ) { expect( user.name ).to eq( @name ) }

    it( 'errors on invalid name' ) do
      expect { Pangit::User.new( @invalid_value_1, @session_id ) }.to raise_error( user_invalid_exc )
      expect { Pangit::User.new( @invalid_value_2, @session_id ) }.to raise_error( user_invalid_exc )
      expect { user.name = @invalid_value_1 }.to raise_error( user_invalid_exc )
      expect { user.name = @invalid_value_2 }.to raise_error( user_invalid_exc )
    end
  end

  describe '#session_id' do
    it( 'has a session id' ) { expect( user.session_id ).to eq( @session_id ) }

    it( 'errors on invalid session_id' ) do
      expect { Pangit::User.new( @name, @invalid_value_1 ) }.to raise_error( session_id_invalid_exc )
      expect { Pangit::User.new( @name, @invalid_value_2 ) }.to raise_error( session_id_invalid_exc )
      expect { user.session_id = @invalid_value_1 }.to raise_error( session_id_invalid_exc )
      expect { user.session_id = @invalid_value_2 }.to raise_error( session_id_invalid_exc )
    end
  end
end

describe Pangit::Room do
  before do
    @name = 'test'
    @key = :test
    @value = :value
  end

  let( :room ) { Pangit::Room.new( @name ) }
  let( :room_invalid_user ) { Pangit::Exceptions::RoomInvalidUser }
  let( :room_user_already_exists ) { Pangit::Exceptions::RoomUserAlreadyExists }

  describe '#name' do
    it( 'has a name' ) { expect( room.name ).to eq( @name ) }
  end

  it( 'has a configuration interface' ) do
    room[@key] = @value
    expect( room[@key] ).to eq( @value )
  end

  describe '.user_exists?' do
    it( 'can check if a user exists already' ) do
      room.add_user( Pangit::User.new( @name, @name ) )
      expect( room.user_exists?( @name ) ).to be( true )
    end

    it( 'can check if a user does not exist' ) do
      expect( room.user_exists?( @name + '_blah' ) ).to be( false )
    end
  end

  describe '.add_user' do
    it( 'errors on invalid user' ) { expect { room.add_user( @name ) }.to raise_error( room_invalid_user ) }
    it( 'errors on duplicate user' ) do
      user = Pangit::User.new( @name + '_duplicate', @name + '_duplicate_session_id' )
      room.add_user( user )
      expect { room.add_user( user ) }.to raise_error( room_user_already_exists )
    end

    it( 'can add users' ) do
      user = Pangit::User.new( @name, @name )
      room.add_user( user )
      expect( room.users.include?( user ) ).to be( true )
    end
  end

  describe '.remove_user' do
    it( 'can delete users' ) do
      user = Pangit::User.new( @name, @name )
      room.add_user( user )
      expect( room.users.include?( user ) ).to be( true )
      room.remove_user( user )
      expect( room.users.include?( user ) ).to be( false )
    end
  end
end
