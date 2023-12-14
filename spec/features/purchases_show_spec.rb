require 'rails_helper'

RSpec.describe 'when opening the purchase details page', type: :feature do
  before(:each) do
    @user = User.create(name: 'Tom', email: 'tom@example.com', password: 'topsecret')

    visit new_user_session_path
    fill_in 'Email', with: 'tom@example.com'
    fill_in 'Password', with: 'topsecret'
    click_button 'Log in'

    @group1 = Group.create(user: @user, name: 'Food', icon: 'https://i.pravatar.cc/300?img=13')
    @group2 = Group.create(user: @user, name: 'Cosmetics', icon: 'https://i.pravatar.cc/300?img=1')
    @purchase1 = Purchase.create(name: 'Apples', amount: 6, author: @user, groups: [@group1, @group2])
    @purchase2 = Purchase.create(name: 'Bananas', amount: 4, author: @user, groups: [@group1])
    visit(group_purchase_path(@group1, @purchase1))
  end

  context 'shows the right content' do
    it 'heading' do
      expect(page).to have_content('Purchase Details')
    end

    it 'name of the purchase' do
      expect(page).to have_content('Apples')
    end

    it 'the created_at attribute of the purchase' do
      expect(page).to have_content(Date.today.strftime('%d %b %Y'), count: 1)
    end

    it 'shows the amount of the purchase' do
      expect(page).to have_content('$6.0')
    end

    it 'shows the GroupList of the selected purchase' do
      expect(page).to have_content('Food')
      expect(page).to have_content('Cosmetics')
    end

    it 'shows delete button' do
      expect(page).to have_button('delete', type: 'submit')
    end

    it 'shows edit button' do
      expect(page).to have_link('edit', href: edit_group_purchase_path(@group1, @purchase1))
    end
  end

  context 'when clicking the delete button' do
    it 'redirects to that group\'s transactions page' do
      click_button('delete')
      expect(page).to have_current_path(group_purchases_url(@group1))
    end

    it "doesn't have that purchase anymore" do
      click_button('delete')
      expect(page).to have_content('Bananas')
      expect(page).to_not have_content('Apples')
    end
  end

  context 'when clicking on edit button' do
    it 'redirects to a form that adds a new transaction' do
      click_link('edit')
      expect(page).to have_current_path(edit_group_purchase_path(@group1, @purchase1))
    end
  end
end
