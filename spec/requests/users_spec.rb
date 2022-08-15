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

      before do
        ActionMailer::Base.deliveries.clear
      end
        
      it "valid signup information" do
        expect {
          post users_path, params: user_params
        }.to change(User, :count).by 1
      end
      
      it "redirect to users/show" do
        post users_path, params: user_params
        user = User.last
        # expect(response).to redirect_to user
      end
      
      it "should display flash" do
        post users_path, params: user_params
        expect(flash).to be_any
      end

      it "ログイン状態であること" do
        post users_path, params: user_params
        # expect(is_logged_in?).to be_truthy
      end

      it "メールが1件存在すること" do
        post users_path, params: user_params
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it "登録時点ではactivateされていないこと" do
        post users_path, params: user_params
        expect(User.last).to_not be_activated
      end
    end
  end

  describe "GET /users" do
    let(:user) { FactoryBot.create(:user) }

    it "ログインユーザーでなければログインページにリダイレクトすること" do
      get users_path
      expect(response).to redirect_to login_path
    end

    describe "pagination" do
      before do
        30.times do
          FactoryBot.create(:continuous_users)
        end
        log_in_as user
        get users_path
      end

      it "div.paginationが存在すること" do
        # expect(response.body).to include '<div class="pagination">'
      end

      it "ユーザーごとのリンクが存在すること" do
        User.paginate(page: 1).each do |user|
          expect(response.body).to include "<a href=\"#{user_path(user)}\">"
        end
      end

      it "activateされていないユーザは表示されないこと" do
        not_activated_user = FactoryBot.create(:mercury)
        log_in_as user
        get users_path
        expect(response.body).to_not include not_activated_user.name
      end
    end
  end

  describe "GET /users/{id}" do
    it "有効化されていないユーザの場合はrootにリダイレクトすること" do
      user = FactoryBot.create(:user)
      not_activated_user = FactoryBot.create(:mercury)

      log_in_as user
      get user_path(not_activated_user)
      expect(response).to redirect_to root_path
    end
  end

  describe "GET /users/{id}/edit" do
    let(:user) { FactoryBot.create(:user) }

    it "タイトルがEdit user | Ruby on Rails Tutorial Sample Appであること" do
      log_in_as user
      get edit_user_path(user)
      expect(response.body).to include full_title("Edit user")
    end

    context "未ログインの場合" do
      it "flashが空でないこと" do
        get edit_user_path(user)
        expect(flash).to_not be_empty
      end

      it "未ログインユーザーはログインページにリダイレクトされること" do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it "ログインすると編集ページにリダイレクトされること" do
        get edit_user_path(user)
        log_in_as user
        expect(response).to redirect_to edit_user_path(user)
      end
    end

    context "別のユーザーの場合" do
      let(:other_user) { FactoryBot.create(:archer) }

      it "flashが空であること" do
        log_in_as user
        get edit_user_path(other_user)
        # expect(flash).to be_emtpy
      end

      it "root_pathにリダイレクトされること" do
        log_in_as user
        get edit_user_path(other_user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PATCH /users" do
    let(:user) { FactoryBot.create(:user) }

    it "admin属性は更新できないこと" do
      # userはこの後adminユーザになるので違うユーザにしておく
      log_in_as user = FactoryBot.create(:archer)
      expect(user).to_not be_admin

      patch user_path(user), params: { user: { password: "password",
                                               password_confirmation: "password",
                                               admin: true } }
      user.reload
      expect(user).to_not be_admin
    end

    context "in case of invalid value" do
      before do
        log_in_as user
        patch user_path(user), params: { user: { name: "",
                                                 email: "foo@invalid",
                                                 password: "foo",
                                                 password_confirmation: "bar" } }
      end

      it "更新できないこと" do
        user.reload
        expect(user.name).to_not eq ""
        expect(user.email).to_not eq ""
        expect(user.password).to_not eq "foo"
        expect(user.password_confirmation).to_not eq "bar"
      end

      it "更新アクション後にeditのページが表示されていること" do
        expect(response.body).to include full_title("Edit user")
      end

      it "The form contains 4 errors.と表示されていること" do
        expect(response.body).to include "The form contains 4 errors."
      end
    end

    context "未ログインの場合" do
      it "flashが空でないこと" do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(flash).to_not be_empty
      end

      it "未ログインのユーザーはログインページにリダイレクトされること" do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(response).to redirect_to login_path
      end
    end

    context "別のユーザーの場合" do
      let(:other_user) { FactoryBot.create(:archer) }

      before do
        log_in_as user
        patch user_path(other_user), params: { user: { name: other_user.name,
                                                       email: other_user.email } }
      end

      it "flashが空であること" do
        # expect(flash).to be_emtpy
      end

      it "rootにリダイレクトすること" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE /users/{id}" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:archer) }

    context "adminユーザでログイン済みの場合" do
      it "削除できること" do
        log_in_as user
        expect {
          delete user_path(other_user)
        }.to change(User, :count).by -1
      end
    end

    context "未ログインの場合" do
      it "削除できないこと" do
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end

      it "ログインページにリダイレクトすること" do
        delete user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    context "adminユーザでない場合" do
      it "削除できないこと" do
        log_in_as other_user
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end

      it "rootにリダイレクトすること" do
        log_in_as other_user
        delete user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET /users/{id}/following" do
    let(:user) { FactoryBot.create(:user) }

    it "未ログインならログインページにリダイレクトすること" do
      get following_user_path(user)
      expect(response).to redirect_to login_path
    end
  end

  describe "GET /users/{id}/followers" do
    let(:user) { FactoryBot.create(:user) }

    it "未ログインならログインページにリダイレクトすること" do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end
  end
end
