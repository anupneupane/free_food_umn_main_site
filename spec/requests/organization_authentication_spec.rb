require 'spec_helper'

describe "when I click on homepage link to signup/signin" do
  before do
    visit '/organizations/sign_in'
  end

  describe "create account via command line, then I can sign in" do
    before do
      Organization.create(email: "test_organization@gmail.com",
                          name: "Test Organization Name",
                          password: "asdQWe132s",
                          password_confirmation: "asdQWe132s")
    end

    it { Organization.count.should == 1 }

    describe "when I sign in without having created an account" do
      before do
        fill_in "organization_email", with: "test_organization@gmail.com"
        fill_in "organization_password", with: "asdQWe132s"
        click_button "Sign in"
      end
  
      it do
        page.should have_selector('div', :class => 'alert', :text => "Signed in successfully.")
      end
    end

  end

  describe "when I sign in without having created an account" do
    before do
      fill_in "organization_email", with: "test_organization@gmail.com"
      fill_in "organization_password", with: "asdQWe132s"
      click_button "Sign in"
    end

    it do
      page.should have_selector('div', :class => 'alert', :text => "Invalid email or password.")
    end
  end

  describe "when I create an account" do
    before do
      click_link "Sign up"
      fill_in "organization_email", with: "test_organization@gmail.com"
      fill_in "organization_name", with: "Test Organization Name"
      fill_in "organization_password", with: "asdQWe132s"
      fill_in "organization_password_confirmation", with: "asdQWe132s"
      click_button "Sign up"
    end

    it { page.should have_selector('div', :class => 'alert', :text => "Welcome! You have signed up successfully.") }
    it { Organization.count.should == 1 }
  end

end
