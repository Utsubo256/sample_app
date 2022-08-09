RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "#index" do
    let!(:admin) { FactoryBot.create(:user) }
    let!(:not_admin) { FactoryBot.create(:archer) }

    it "adminユーザならdeleteリンクが表示されること" do
      log_in_as admin
      visit users_path

      expect(page).to have_link "delete"
    end

    it "adminユーザでなければdeleteリンクが表示されないこと" do
      log_in_as not_admin
      visit users_path

      expect(page).to_not have_link "delete"
    end
  end

  describe "#create" do
    context "in case of invalid" do
      it "invalid signup information" do
        visit signup_path
        fill_in "Name", with: ""
        fill_in "Email", with: "user@invalid"
        fill_in "Password", with: "foo"
        fill_in "Confirmation", with: "bar"
        click_button "Create my account"

        expect(page).to have_selector "div#error_explanation"
        expect(page).to have_selector "div.field_with_errors"
      end
    end
  end
end
