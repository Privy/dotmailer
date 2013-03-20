require 'spec_helper'

describe DotMailer::Account do
  let(:api_user) { double 'api user' }
  let(:api_pass) { double 'api pass' }
  let(:client)   { double 'client' }

  subject { DotMailer::Account.new(api_user, api_pass) }

  before(:each) do
    subject.stub :client => client
  end

  describe '#initialize' do
    before(:each) do
      DotMailer::Client.stub :new => client
    end

    it 'should initialize a Client with the credentials' do
      DotMailer::Client.should_receive(:new).with(api_user, api_pass)

      DotMailer::Account.new(api_user, api_pass)
    end

    it 'should set the client' do
      DotMailer::Client.should_receive(:new).with(api_user, api_pass)

      account = DotMailer::Account.new(api_user, api_pass)
    end
  end

  describe '#suppress' do
    let(:email) { double 'email' }

    before(:each) do
      client.stub :post_json
    end

    it 'should call post_json on the client with the correct path' do
      client.should_receive(:post_json).with('/contacts/unsubscribe', anything)

      subject.suppress email
    end

    it 'should call post_json on the client with the email address' do
      client.should_receive(:post_json).with(anything, 'Email' => email)

      subject.suppress email
    end
  end

  describe '#data_fields' do
    let(:data_fields) { double 'data fields' }
    let(:cache)       { double 'cache' }

    before(:each) do
      subject.stub :cache => cache
    end

    context 'when the cache is empty' do
      before(:each) do
        cache.stub(:fetch).with('data_fields').and_yield
        DotMailer::DataField.stub :all => data_fields
      end

      it 'should call DataField.all' do
        DotMailer::DataField.should_receive(:all).with(subject)

        subject.data_fields
      end

      its(:data_fields) { should == data_fields }
    end

    context 'when the cache is not empty' do
      before(:each) do
        cache.stub(:fetch).with('data_fields').and_return(data_fields)
      end

      it 'should not call DataField.all' do
        DotMailer::DataField.should_not_receive(:all)

        subject.data_fields
      end

      its(:data_fields) { should == data_fields }
    end
  end

  describe '#create_data_field' do
    let(:name)    { double 'name' }
    let(:options) { double 'options' }
    let(:cache)   { double 'cache' }

    before(:each) do
      subject.stub :cache => cache
      DotMailer::DataField.stub :create
      cache.stub :delete
    end

    it 'should DataField.create' do
      DotMailer::DataField.should_receive(:create).with(subject, name, options)

      subject.create_data_field(name, options)
    end

    it 'should clear the data_fields from the cache' do
      cache.should_receive(:delete).with('data_fields')

      subject.create_data_field(name, options)
    end
  end
end
