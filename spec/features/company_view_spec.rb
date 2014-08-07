require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the company view', type: :feature do
  let(:company) { Company.create(name: "Microcenter")}

  describe "phone numbers" do
    before(:each) do
      company.phone_numbers.create(number: "123-1234")
      company.phone_numbers.create(number: "123-9876")
    visit company_path(company)
    end

    it 'shows the phone number' do
      company.phone_numbers.each do |phone|
        expect(page).to have_content(phone.number)
      end
    end

    it 'has a link to add a new number' do
      expect(page).to have_link('Add phone number', href: new_phone_number_path(contact_id: company.id, contact_type: "Company"))
    end

    it 'adds a new phone number' do
      click_link('Add phone number')
      page.fill_in('Number', with: '123-4567')
      page.click_button('Create Phone number')
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('123-4567')
    end
  end

end
