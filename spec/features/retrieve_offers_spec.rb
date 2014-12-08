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
    fill_in 'pub0', with: 'campaign1'
    fill_in 'page', with: '1'
    click_button 'Get offers'

    expect(page).to have_text('UID field is required')
  end

  scenario "when return offers" do
    fill_in 'uid', with: 'user1'
    fill_in 'pub0', with: 'campaign1'
    fill_in 'page', with: '1'

    VCR.use_cassette('offers_present') do
      click_button 'Get offers'
    end

    within('.offer') do
      expect(page.find('.title')).to have_text('Tap  Fish')
      expect(page.find('.payout')).to have_text('90')
      expect(page.find('.thumbnail')).to have_text('http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_60.png') 
    end
  end

  scenario "when don't return offers" do
    fill_in 'uid', with: 'user2'
    fill_in 'pub0', with: ''
    fill_in 'page', with: ''

    VCR.use_cassette('offers_empty') do
      click_button 'Get offers'
    end

    within('.no_offers') do
      expect(page).to have_text('No offers')
    end
  end
end
