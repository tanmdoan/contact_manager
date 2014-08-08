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

    it 'has a link to edit phone numbers' do
      company.phone_numbers.each do |phone|
        expect(page).to have_link('edit', href: edit_phone_number_path(phone))
      end
    end

    it 'edits a phone number' do
      phone_number = company.phone_numbers.first
      old_number = phone_number.number

      first(:link, 'edit').click
      page.fill_in('Number', with: '1800google')
      page.click_button('Update Phone number')
      expect(current_path).to eq(company_path(company))
      expect(page).to_not have_content(old_number)
      expect(page).to have_content('1800google')
    end

    it 'has a link to delete phone numbers' do
      company.phone_numbers.each do |phone|
        expect(page).to have_link('destroy', href: phone_number_path(phone))
      end
    end

    it 'deletes a phone number' do
      first_number = company.phone_numbers.first
      last_number = company.phone_numbers.last

      first(:link, 'destroy').click
      expect(page).to have_content(last_number.number)
      expect(page).to_not have_content(first_number.number)
    end
  end

  describe 'email addresses' do
    before(:each) do
      company.email_addresses.create(address: "boby@example.com")
      company.email_addresses.create(address: "will@example.com")
      visit company_path(company)
    end

    it 'shows emails' do
      company.email_addresses.each do |email|
        expect(page).to have_content(email.address)
      end
    end

    it 'has link to add new email' do
      expect(page).to have_link('Add email address', href: new_email_address_path(contact_id: company.id, contact_type: "Company"))
    end

    it 'adds a new email' do
      page.click_link('Add email address')
      page.fill_in('Address', with: 'new@example.com')
      page.click_button('Create Email address')
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('new@example.com')
    end

    it 'has a link to edit emails' do
      company.email_addresses.each do |email|
        expect(page).to have_link('edit', href: edit_email_address_path(email))
      end
    end

    it 'edits an email address' do
      email = company.email_addresses.first
      old_address =  email.address

      first(:link, 'edit').click
      page.fill_in('Address', with: 'edit@example.com')
      page.click_button('Update Email address')
      expect(page).to_not have_content(old_address)
      expect(page).to have_content('edit@example.com')
    end

    it 'has a link to destroy email address' do
      company.email_addresses.each do |email|
        expect(page).to have_link('destroy', href: email_address_path(email))
      end
    end

    it 'deletes an email address' do
      first_address = company.email_addresses.first
      last_address = company.email_addresses.last
      first(:link, 'destroy').click
      expect(page).to have_content(last_address.address)
      expect(page).to_not have_content(first_address.address)
    end
  end

end
