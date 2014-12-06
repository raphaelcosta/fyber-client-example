require 'rails_helper'

feature 'Retrieve offers', %q{
  As an user
  I want to retrieve offers
  providing uid, pub0 and page
  In order to view offers
} do
  background do
    visit root_path
  end

  scenario 'when uid field is empty' do
    fill_in 'page', with: 'campaign1'
    fill_in 'page', with: '1'
    click_button 'Get offers'

    expect(page).to have_text('UID is required')
  end

  scenario "when don't return offers" do
    fill_in 'uid', with: 'user1'
    fill_in 'page', with: 'campaign1'
    fill_in 'page', with: '1'
    click_button 'Get offers'

    within('.offer') do
      expect(page.find('.title')).to have_text('Offer Title')
      expect(page.find('.payout')).to have_text('Offer Payout')
      expect(page.find('.thumbnail')).to have_text('Offer Thumbnail')
    end
  end

  scenario "when return offers" do
    fill_in 'uid', with: 'user2'
    fill_in 'page', with: ''
    fill_in 'page', with: ''
    click_button 'Get offers'

    within('.no_offers') do
      expect(page).to have_text('No offers')
    end
  end
end
