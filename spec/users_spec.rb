require 'pangit/models/users'

describe Pangit::Models::Users do
  before( :all ) do
    Pangit::DataStore.class_variable_set( :@@instance, nil )
    Pangit::Models::Users.register
  end

  let( :name ) { 'Matt Meng' }
  let( :session_id ) { '4' }

  describe '.add_user' do
    it( 'errors if a session id already exists' ) do
      Pangit::Models::Users.add_user( name, session_id )
      expect { Pangit::Models::Users.add_user( name, session_id ) }.to raise_error( Pangit::Exceptions::UserSessionIDAlreadyExists )
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