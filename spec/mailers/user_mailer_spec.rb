require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "Account activationというタイトルで送信されること" do
      expect(mail.subject).to eq("Account activation")
    end

    it "送信先がto@example.orgであること" do
      expect(mail.to).to eq([user.email])
    end

    it "送信先がfrom@example.comであること" do
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "メール本文にユーザ名が表示されていること" do
      expect(mail.body.encoded).to match(user.name)
    end

    it "メール本文にユーザのactivation_tokenが表示されていること" do
      expect(mail.body.encoded).to match(user.activation_token)
    end

    it "メール本文にユーザのemailが表示されていること" do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end
