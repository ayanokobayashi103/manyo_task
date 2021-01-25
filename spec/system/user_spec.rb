require 'rails_helper'
RSpec.describe 'User', type: :system do
  describe 'ユーザ登録のテスト' do
    context 'ユーザの新規登録ができること' do
      it '作成したタスクが表示される' do
        visit new_user_path
        fill_in 'user[name]', with:'name'
        fill_in 'user[email]', with:'email@e.com'
        fill_in 'user[password]', with:'password'
        fill_in 'user[password_confirmation]', with:'password'
        click_on 'Create my account'
        expect(page).to have_content '新規登録しました！'
      end
    end
    context 'ログインせずタスク一覧に飛ぶとログイン画面に遷移' do
      it 'ログイン画面へ飛ばす' do
        visit tasks_path
        expect(page).to have_content 'ログインが必要です！！！！！！'
      end
    end
  end

  describe 'セッション機能のテスト' do
    before do
      FactoryBot.create(:user)
    end
    context 'ログインができること' do
      it 'ログインページに遷移' do
        visit new_session_path
        fill_in 'session[email]', with:'user@u.com'
        fill_in 'session[password]', with:'userpass1'
        click_on 'Log in'
        expect(page).to have_content 'user1ログイン中'
      end
    end
end
end
