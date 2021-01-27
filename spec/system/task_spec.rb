require 'rails_helper'
RSpec.describe 'Task', type: :system do
  before do
    FactoryBot.create(:admin_user)
    user1 = FactoryBot.create(:user)
    visit new_session_path
    fill_in 'session[email]', with:'user@u.com'
    fill_in 'session[password]', with:'userpass1'
    click_on 'Log in'
    FactoryBot.create(:task, title: 'task', status: 2, priority: 1,user: user1)
    FactoryBot.create(:second_task, id:2,title: 'sample', deadline: Time.current + 3.days, priority: 3,user: user1)
  end
  describe '検索機能' do
    before do
      visit tasks_path
    end
    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        fill_in 'search', with:'task'
        click_on 'Search'
        expect(page).to have_content 'task'
      end
    end
    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        select "完了", from: "status"
        click_on 'Search'
        expect(page).to have_content 'task'
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        fill_in 'search', with:'sample'
        select "未着手", from: "status"
        click_on 'Search'
        expect(page).to have_content 'newest'
      end
    end
  end

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'task[title]', with:'task_title'
        fill_in 'task[content]', with:'task_content'
        click_on 'Create my task'
        expect(page).to have_content '作成しました！'
      end
    end
  end

  describe '一覧表示機能' do
    before do
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        expect(page).to have_content 'task'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        click_on '作成日時でソートする'
        sleep(1)
        task_list = all('tr')
        latest = task_list[1]
        expect(latest).to have_content 'newest'
      end
    end
    context 'タスクが終了期限の降順に並んでいる場合' do
      it '終了期限が近いものが一番上に表示される' do
        click_on '終了期限でソートする'
        sleep(1)
        task_list = all('tr')
        closest_deadline = task_list[1]
        expect(closest_deadline).to have_content 'task'
      end
    end
    context '優先順位が高い順に並んでいる場合' do
      it '優先度の高が一番上に表示される' do
        click_on '優先度'
        sleep(1)
        priority = all('tr')
        high_priority = priority[1]
        expect(high_priority).to have_content '高'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit tasks_path
        page.all("#show_link")[1].click
        expect(page).to have_content 'sample'
      end
    end
  end
end
