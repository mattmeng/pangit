require 'pangit/models/users'

describe Pangit::Models::Users do
  before( :each ) do
    Pangit::DataStore.instance.instance_variable_set( :@store, {} )
    Pangit::Models::Users.register
  end

  let( :name ) { 'Matt Meng' }
  let( :session_id ) { '4' }
  let( :users ) { Pangit::Models::Users }
  let( :user_session_id_already_exists ) { Pangit::Exceptions::UserSessionIDAlreadyExists }

  describe '.add_user' do
    it( 'errors if a session id already exists' ) do
      users.add_user( name, session_id )
      expect { users.add_user( name, session_id ) }.to raise_error( user_session_id_already_exists )
    end
  end

  describe '[]' do
    it( 'returns nil if no value exists' ) { expect( users[name] ).to be_nil }
    it( 'returns value' ) do
      users.add_user( name, session_id )
      expect( users[session_id] ).not_to be_nil
    end
  end
end

describe Pangit::Models::User do
  let( :name ) { 'test' }
  let( :name_nil ) { nil }
  let( :name_number ) { 4 }
  let( :name_blank ) { ' ' }
  let( :session_id ) { '4' }
  let( :session_id_nil ) { nil }
  let( :session_id_number ) { 4 }
  let( :session_id_blank ) { ' ' }
  let( :user ) { Pangit::Models::User.new( name, session_id ) }
  let( :user_invalid_exc ) { Pangit::Exceptions::UserNameInvalid }
  let( :session_id_invalid_exc ) { Pangit::Exceptions::UserSessionIDInvalid }

  describe '#name' do
    it( 'has a name' ) { expect( user.name ).to eq( name ) }

    it( 'errors on invalid name' ) do
      expect { Pangit::Models::User.new( name_nil, session_id ) }.to raise_error( user_invalid_exc )
      expect { Pangit::Models::User.new( name_number, session_id ) }.to raise_error( user_invalid_exc )
      expect { Pangit::Models::User.new( name_blank, session_id ) }.to raise_error( user_invalid_exc )
      expect { user.name = name_nil }.to raise_error( user_invalid_exc )
      expect { user.name = name_number }.to raise_error( user_invalid_exc )
      expect { user.name = name_blank }.to raise_error( user_invalid_exc )
    end
  end

  describe '#id' do
    it( 'has an id' ) { expect( user.id ).to eq( session_id ) }

    it( 'errors on invalid session_id' ) do
      expect { Pangit::Models::User.new( name, name_nil ) }.to raise_error( session_id_invalid_exc )
      expect { Pangit::Models::User.new( name, name_number ) }.to raise_error( session_id_invalid_exc )
      expect { Pangit::Models::User.new( name, name_blank ) }.to raise_error( session_id_invalid_exc )
    end
  end
end