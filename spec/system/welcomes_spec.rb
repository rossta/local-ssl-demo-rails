require 'rails_helper'

RSpec.feature "Welcome", :js, type: :system do
  scenario "Visit homepage" do
    using_app_host('https://subdomain.localhost.ross') do
      visit "/"

      expect(page).to have_content('Welcome')
      expect(page).to have_content('Hello from Webpack')

      expect(page).to have_content('Your domain: subdomain.localhost.ross')
      expect(page).to have_content('Your protocol: https://')
    end
  end
end
