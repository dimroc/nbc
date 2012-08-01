require 'spec_helper'

feature 'worlds', js: true do
  scenario 'user visits new york city' do
    visit root_path

    click_on "New York City"

    wait_until do
      page.evaluate_script("_.isEmpty(App.worldRenderers) == false")
    end

    page.should have_css("canvas")
  end
end
