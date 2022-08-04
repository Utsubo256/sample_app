require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end

    it 'Sign up | Ruby on Rails Tutorial Sample Appが含まれること' do
      get signup_path
      expect(response.body).to include full_title('Sign up')
    end
  end

  describe "POST /users #create" do
    it "invalid signup information" do
      get signup_path
      expect {
        post users_path, params: { user: { name: "",
                                           email: "user@invalid",
                                           password: "foo",
                                           password_confirmation: "bar" } }
        }.to_not change(User, :count)
    end

    
    context "in case of valid value" do
      let(:user_params) { { user: { name: "Example User",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password" } } }
        
      it "valid signup information" do
        expect {
          post users_path, params: user_params
        }.to change(User, :count).by 1
      end
      
      it "redirect to users/show" do
        post users_path, params: user_params
        user = User.last
        expect(response).to redirect_to user
      end
      
      it "should display flash" do
        post users_path, params: user_params
        expect(flash).to be_any
      end

      it "ログイン状態であること" do
        post users_path, params: user_params
        expect(is_logged_in?).to be_truthy
      end
    end
  end
end
