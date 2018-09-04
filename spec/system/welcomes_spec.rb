require 'rails_helper'

RSpec.feature "Welcome", :js, type: :system do
  scenario "Visit homepage" do
    using_app_host('https://subdomain.system-test-demo.test') do
      visit "/"

      expect(page).to have_content('Welcome')
      expect(page).to have_content('Hello Vue')

      expect(page).to have_content('Your domain: subdomain.system-demo-test.test')
      expect(page).to have_content('Your protocol: https://')
    end
  end
end
