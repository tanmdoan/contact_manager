require 'rails_helper'

RSpec.describe EmailAddress, :type => :model do
  let(:email_address) { EmailAddress.new(address: "hi@example.com", person_id: 1 ) }

  it 'is valid' do
    expect(email_address).to be_valid
  end

  it 'is not valid without an address' do
    email_address.address = nil
    expect(email_address).not_to be_valid
  end

  it 'is not valid without a person id' do
    email_address.person_id = nil
    expect(email_address).not_to be_valid
  end
end
