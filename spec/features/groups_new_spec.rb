require 'rails_helper'

RSpec.describe 'when opening the new groups page', type: :feature do
  before(:each) do
    @user = User.create(name: 'Tom', email: 'tom@example.com', password: 'topsecret')

    visit new_user_session_path
    fill_in 'Email', with: 'tom@example.com'
    fill_in 'Password', with: 'topsecret'
    click_button 'Log in'

    @group1 = Group.create(user: @user, name: 'Food', icon: 'https://i.pravatar.cc/300?img=13')
    @group2 = Group.create(user: @user, name: 'Cosmetics', icon: 'https://i.pravatar.cc/300?img=1')
    @purchase1 = Purchase.create(name: 'Apples', amount: 5, author: @user, groups: [@group1])
    @purchase2 = Purchase.create(name: 'Bananas', amount: 5, author: @user, groups: [@group1])
    visit(new_group_path)
  end
  context 'shows the correct' do
    it 'heading' do
      expect(page).to have_content('New Category')
    end

    it 'labels' do
      expect(page).to have_content('Name')
      expect(page).to have_content('Icon link *')
    end

    it 'placeholders' do
      expect(page).to have_css("input[placeholder='Clothes']")
      expect(page).to have_css("input[placeholder='https://i.pravatar.cc/300?img=5']")
    end

    it 'add category button' do
      expect(page).to have_button('add category', type: 'submit')
    end
  end

  context 'fill in the fields and click on a add category button' do
    before(:each) do
      fill_in 'Name', with: 'Clothes'
      fill_in 'Icon', with: 'https://i.pravatar.cc/300?img=5'
      click_button('add category')
    end

    it 'redirects to that group\'s list page' do
      expect(page).to have_current_path(groups_path)
    end

    it 'the groups list page shows the newly added group' do
      expect(page).to have_content('Clothes')
    end
  end

  context 'clicks on a add category button without filling the form' do
    it 'renders the new page again' do
      click_button('add category')
      expect(page).to have_content('New Category')
      expect(page).to have_button('add category', type: 'submit')
    end

    it 'shows an error message' do
      click_button('add category')
      expect(page).to have_content('Name can\'t be blank and Icon can\'t be blank')
    end
  end
end
