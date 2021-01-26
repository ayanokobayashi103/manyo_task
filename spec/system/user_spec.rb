require 'rails_helper'
RSpec.describe 'User', type: :system do
  before do
    # 管理者が0人になってしまうので最小に管理者を作成
    FactoryBot.create(:admin_user)
  end
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
      visit new_session_path
      fill_in 'session[email]', with:'user@u.com'
      fill_in 'session[password]', with:'userpass1'
      click_on 'Log in'
    end
    context 'ログインができること' do
      it 'ログインページに遷移' do
        expect(page).to have_content 'user1ログイン中'
      end
    end
    context '自分の詳細画面(マイページ)に飛べること' do
      it 'マイページが表示される' do
        visit tasks_path
        click_on 'Profile'
        expect(page).to have_content 'user1のページ'
      end
    end
    context '他人の詳細画面に飛べないこと' do
      it '自分のタスク一覧に遷移する' do
        FactoryBot.create(:user2, id: 2)
        visit user_path(2)
        expect(page).to have_content 'エラー'
      end
    end
    context 'ログアウトができること' do
      it 'ログアウトしたことがわかる表示が出る' do
        visit tasks_path
        click_on 'Logout'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end
  describe '管理画面のテスト' do
    let!(:user) { FactoryBot.create(:user, id:1) }
    context '一般ユーザは管理画面にアクセスできないこと' do
      it 'ユーザーのページに戻ってくること' do
        visit new_session_path
        fill_in 'session[email]', with:'user@u.com'
        fill_in 'session[password]', with:'userpass1'
        click_on 'Log in'
        visit admin_users_path
        expect(page).to have_content '管理者のみアクセスできます'
      end
    end
    context '管理ユーザは管理画面にアクセスできること' do
      before do
        visit new_session_path
        #　管理者がログイン
        fill_in 'session[email]', with:'admin@a.com'
        fill_in 'session[password]', with:'adminpass'
        click_on 'Log in'
      end
      it 'ユーザーの一覧画面を表示できること' do
        visit admin_users_path
        expect(page).to have_content 'ユーザーの一覧'
      end
      it '管理ユーザはユーザの新規登録ができること' do
        visit new_admin_user_path
        fill_in 'user[name]', with:'新しいユーザー'
        fill_in 'user[email]', with:'email@e.com'
        fill_in 'user[password]', with:'password'
        fill_in 'user[password_confirmation]', with:'password'
        click_on 'Create this account'
        expect(page).to have_content '新しいユーザー'
      end
      it '管理ユーザはユーザの詳細画面にアクセスできること' do
        visit admin_user_path(1)
        expect(page).to have_content 'user1のタスク一覧'
      end
      it '管理ユーザはユーザの編集画面からユーザを編集できること' do
        visit edit_admin_user_path(1)
        fill_in 'user[password]', with:'password'
        fill_in 'user[password_confirmation]', with:'password'
        click_on 'Update this account'
        expect(page).to have_content 'user1を編集しました'
      end
      it '管理ユーザはユーザの削除をできること' do
        visit admin_users_path
        page.all(".delete-user")[1].click
        #  page.driver.browser.switch_to.alert.accept
         page.accept_confirm
        expect(page).to have_content '削除しました'
      end
    end
  end
end
