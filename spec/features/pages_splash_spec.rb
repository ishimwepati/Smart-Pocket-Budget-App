require 'rails_helper'

RSpec.describe 'when opening the webpage for the first time', type: :feature do
  before(:each) do
    visit unauthenticated_root_path
  end

  context 'shows the correct' do
    it 'heading' do
      expect(page).to have_content('SmartPocket Budget')
    end

    it 'links' do
      expect(page).to have_link('log in', href: new_user_session_path)
      expect(page).to have_link('sign up', href: new_user_registration_path)
    end
  end

  context 'when clicking on the link' do
    it 'redirects to the sign in page' do
      click_on('log in')
      expect(page).to have_current_path(new_user_session_path)
    end

    it 'redirects to the sign up page' do
      click_on('sign up')
      expect(page).to have_current_path(new_user_registration_path)
    end
  end

  context 'when signing up with the valid attributes' do
    before(:each) do
      click_on('sign up')
      fill_in 'Name', with: 'Tom'
      fill_in 'Email', with: 'tom@example.com'
      fill_in 'user_password', with: 'topsecret'
      fill_in 'user_password_confirmation', with: 'topsecret'
      click_button 'Sign up'
    end

    it 'redirects to the splash page' do
      expect(page).to have_current_path(unauthenticated_root_path)
    end
  end

  context 'when signing up with the valid attributes' do
    before(:each) do
      @user = User.create(name: 'Tom', email: 'tom@example.com', password: 'topsecret')
      visit new_user_session_path

      fill_in 'Email', with: 'tom@example.com'
      fill_in 'Password', with: 'topsecret'
      click_button 'Log in'
    end

    it 'redirects to the groups page' do
      expect(page).to have_current_path(authenticated_root_path)
    end

    it 'redirects to the sign up page' do
      expect(page).to have_content('Categories')
    end
  end
end
