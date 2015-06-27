require 'pangit/models/users'

describe Pangit::Models::Users do
  before( :each ) do
    Pangit::DataStore.instance.instance_variable_set( :@store, {} )
    Pangit::Models::Users.register
  end

  let( :name ) { 'Matt Meng' }
  let( :session_id ) { '4' }
  let( :users ) { Pangit::Models::Users }

  describe '.add_user' do
    let( :user_session_id_already_exists ) { Pangit::Exceptions::UserSessionIDAlreadyExists }

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
  let( :session_id ) { '4' }
  let( :user ) { Pangit::Models::User }
  let( :test_user ) { user.new( name, session_id ) }

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
end