# frozen_string_literal: true

describe OmniAuth::Strategies::KeycloakOpenId do
  subject do
    described_class.new({}, client_id, client_secret, client_options: client_options).tap do |strategy|
      allow(strategy).to receive_messages(request: request, session: [])
    end
  end

  let(:client_id) { "Example-Client" }
  let(:client_secret) { "Example-Secret" }
  let(:client_options) { { site: "https://fake.keycloakopenid.site", realm: "example-realm" } }
  let(:request) { double("Request", params: {}, cookies: {}, env: {}, scheme: "https", url: "") }

  let(:nickname) { Faker::Internet.username(specifier: 5..10, separators: []) }
  let(:email) { Faker::Internet.email }
  let(:name) { Faker::Name.name }

  let(:raw_info_hash) do
    {
      "preferred_username" => nickname,
      "email" => email,
      "name" => name
    }
  end

  describe "client options" do
    it "has correct name" do
      expect(subject.options.name).to eq("keycloakopenid")
    end

    it "has correct client id" do
      expect(subject.options.client_id).to eq(client_id)
    end

    it "has correct client secret" do
      expect(subject.options.client_secret).to eq(client_secret)
    end

    it "has correct site" do
      expect(subject.options.client_options.site).to eq(client_options[:site])
    end

    it "has correct realm" do
      expect(subject.options.client_options.realm).to eq(client_options[:realm])
    end
  end

  describe "info" do
    before do
      # rubocop: disable RSpec/SubjectStub
      allow(subject).to receive(:raw_info).and_return(raw_info_hash)
      # rubocop: enable RSpec/SubjectStub
    end

    it "returns the uid" do
      expect(subject.uid).to eq(nickname)
    end

    it "returns the nickname" do
      expect(subject.info[:nickname]).to eq(nickname)
    end

    it "returns the email" do
      expect(subject.info[:email]).to eq(email)
    end

    it "returns the name" do
      expect(subject.info[:name]).to eq(name)
    end
  end
end
