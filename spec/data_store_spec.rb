require 'spec_helper'
require 'pangit'

describe Pangit::DataStore do
  let( :data_store ) { Pangit::DataStore.instance }

  it 'gives back the same instance' do
    expect( Pangit::DataStore.instance.object_id ).to eq( Pangit::DataStore.instance.object_id )
  end

  describe '.add_store' do
    after( :each ) { data_store.instance_variable_set( :@store, {} ) }

    let( :key ) { :test }
    let( :key_string ) { 'test' }
    let( :store_array ) { [] }
    let( :store_hash ) { {} }

    it( 'errors on invalid key' ) { expect { data_store.add_store( key_string, store_array ) }.to raise_error( Pangit::Exceptions::DataStoreInvalidKey ) }
    it( 'errors on invalid store' ) { expect { data_store.add_store( key, key_string ) }.to raise_error( Pangit::Exceptions::DataStoreInvalidStore ) }
    it( 'errors if store already exists' ) do
      data_store.add_store( key, store_array )
      expect { data_store.add_store( key, store_hash ) }.to raise_error( Pangit::Exceptions::DataStoreAlreadyExists )
    end
    it( 'adds a valid store room array' ) { expect( data_store.add_store( key, store_array ) ).to be( key ) }
    it( 'adds a valid store room hash' ) { expect( data_store.add_store( key, store_hash ) ).to be( key ) }
  end

  describe '[]' do
    it( 'returns expected value' ) do
      key = :test
      store = []
      data_store.add_store( key, store )
      expect( data_store[key] ).to eq( store )
    end
  end
end

# describe Pangit::Room do
#   before do
#     @name = 'test'
#     @key = :test
#     @value = :value
#   end

#   let( :room ) { Pangit::Room.new( @name ) }
#   let( :room_invalid_user ) { Pangit::Exceptions::RoomInvalidUser }
#   let( :room_user_already_exists ) { Pangit::Exceptions::RoomUserAlreadyExists }

#   describe '#name' do
#     it( 'has a name' ) { expect( room.name ).to eq( @name ) }
#   end

#   it( 'has a configuration interface' ) do
#     room[@key] = @value
#     expect( room[@key] ).to eq( @value )
#   end

#   describe '.user_exists?' do
#     it( 'can check if a user exists already' ) do
#       user = :test_exists
#       room.add_user( user )
#       expect( room.user_exists?( user ) ).to be( true )
#     end

#     it( 'can check if a user does not exist' ) do
#       expect( room.user_exists?( @name + '_blah' ) ).to be( false )
#     end
#   end

#   describe '.add_user' do
#     it( 'errors on invalid user' ) { expect { room.add_user( @name ) }.to raise_error( room_invalid_user ) }
#     it( 'errors on duplicate user' ) do
#       user = :test_duplicate
#       room.add_user( user )
#       expect { room.add_user( user ) }.to raise_error( room_user_already_exists )
#     end

#     it( 'can add users' ) do
#       user = :test_add
#       room.add_user( user )
#       expect( room.users.include?( user ) ).to be( true )
#     end
#   end

#   describe '.remove_user' do
#     it( 'can remove users' ) do
#       user = :test_remove
#       room.add_user( user )
#       expect( room.users.include?( user ) ).to be( true )
#       room.remove_user( user )
#       expect( room.users.include?( user ) ).to be( false )
#     end
#   end
# end
