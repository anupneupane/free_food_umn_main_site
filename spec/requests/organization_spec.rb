require "spec_helper"

describe "organization" do
  before do
    Organization.create!(
      email: "test@gmail.com",
      password: "test_password",
      password_confirmation: "test_password",
      url: "http://test.com",
      description: "test description",
    )
  end

  describe "sign in" do
    before do
      visit '/view_by_week'
      click_link "Campus groups sign in"
      fill_in "organization_email", with: "test@gmail.com"
      fill_in "organization_password", with: "test_password"
      click_button "Sign in"
    end

    it { page.should have_selector("div", text: "Signed in successfully.") }
    it { page.should have_selector("a", text: "Sign out") }
    it { page.should have_selector("a", text: "Edit organization details") }

    describe "edit organization" do
      before do
        click_link "Edit organization details"
      end

      describe "change description" do
        let(:organization) do
          fill_in "organization_description", with: "test description 2"
          fill_in "organization_current_password", with: "test_password"
          click_button "Update"
          Organization.where(email: "test@gmail.com").first
        end

        it { organization.description.should == "test description 2" }
      end

      describe "change url" do
        let(:organization) do
          fill_in "organization_url", with: "http://testurl2.com"
          fill_in "organization_current_password", with: "test_password"
          click_button "Update"
          Organization.where(email: "test@gmail.com").first
        end

        it { organization.url.should == "http://testurl2.com" }
      end

      describe "change name" do
        let(:organization) do
          fill_in "organization_name", with: "name 2"
          fill_in "organization_current_password", with: "test_password"
          click_button "Update"
          Organization.where(email: "test@gmail.com").first
        end

        it { organization.name.should == "name 2" }
      end
    end
  end
end
