require 'spec_helper'
require 'pangit'

describe Pangit::DataStore do
  let( :data_store ) { Pangit::DataStore }
  it 'gives back the same instance' do
    expect( data_store.instance.object_id ).to eq( data_store.instance.object_id )
  end
end

describe Pangit::User do
  before do
    @name = 'test'
    @session_id = 4
  end

  let( :user ) { Pangit::User.new( @name, @session_id ) }
  it( 'has a name' ) { expect( user.name ).to eq( @name ) }
  it( 'has a session id' ) { expect( user.session_id ).to eq( @session_id ) }
end