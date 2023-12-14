require 'rails_helper'

RSpec.describe 'when opening the purchase edit page', type: :feature do
  before(:each) do
    @user = User.create(name: 'Tom', email: 'tom@example.com', password: 'topsecret')

    visit new_user_session_path
    fill_in 'Email', with: 'tom@example.com'
    fill_in 'Password', with: 'topsecret'
    click_button 'Log in'

    @group1 = Group.create(user: @user, name: 'Food', icon: 'https://i.pravatar.cc/300?img=13')
    @group2 = Group.create(user: @user, name: 'Cosmetics', icon: 'https://i.pravatar.cc/300?img=1')
    @purchase1 = Purchase.create(name: 'Apples', amount: 5, author: @user, groups: [@group1])
    @purchase2 = Purchase.create(name: 'Bananas', amount: 10, author: @user, groups: [@group1, @group2])
    visit(edit_group_purchase_path(@group1, @purchase1))
  end

  context 'shows the correct' do
    it 'heading' do
      expect(page).to have_content('Edit transaction')
    end

    it 'labels' do
      expect(page).to have_content('name')
      expect(page).to have_content('amount, $')
      expect(page).to have_content('choose categories')
    end

    it 'existing groups' do
      expect(page).to have_content('Food')
      expect(page).to have_content('Cosmetics')
    end

    it 'placeholders' do
      expect(page).to have_css("input[value='Apples']")
      expect(page).to have_css("input[value='5.0']")
    end

    it 'updates the transaction button' do
      expect(page).to have_button('update', type: 'submit')
    end
  end

  context 'when filling in the fields and click on update button' do
    before(:each) do
      fill_in 'name', with: 'Cream'
      fill_in 'amount', with: '15'
      uncheck 'Food'
      check 'Cosmetics'
      click_button('update')
    end

    it 'redirects to that transaction\'s details page' do
      expect(page).to have_current_path(group_purchases_path(@group1))
    end

    it 'unchecking the group transactions page and shows the correct transactions' do
      visit(group_purchases_path(@group1))
      expect(page).to_not have_content('Cream')
      expect(page).to_not have_content('Apples')
      expect(page).to have_content('Bananas')
      expect(page).to_not have_content('$15.0')
      expect(page).to have_content('$10.0', count: 2)
    end

    it 'unchecking the group transactions page and shows the updated transactions' do
      visit(group_purchases_path(@group2))
      expect(page).to have_content('Cream')
      expect(page).to have_content('Banana')
      expect(page).to_not have_content('Apples')
      expect(page).to have_content('$15.0')
      expect(page).to have_content('$10.0')
      expect(page).to have_content('$25.0')
    end
  end
end
