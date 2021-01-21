require 'rails_helper'
RSpec.describe 'Task', type: :system do
  describe '検索機能' do
    before do
      FactoryBot.create(:task, title: "task", status: 2)
      FactoryBot.create(:second_task, title: "sample")
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
    let!(:task) { FactoryBot.create(:task, title: 'task', priority: 1) }
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを作成
        # タスク一覧ページに遷移
        visit tasks_path
        # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
        # have_contentされているか（含まれているか）ということをexpectする（確認・期待する）
        expect(page).to have_content 'task'
        # expectの結果が true ならテスト成功、false なら失敗として結果が出力される
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        FactoryBot.create(:second_task)
        visit tasks_path
        click_on '作成日時でソートする'
        sleep(2)
        task_list = all('tr')
        latest = task_list[1]
        expect(latest).to have_content 'newest'
      end
    end
    context 'タスクが終了期限の降順に並んでいる場合' do
      it '終了期限が近いものが一番上に表示される' do
        FactoryBot.create(:second_task, deadline: Time.current + 3.days)
        visit tasks_path
        click_on '終了期限でソートする'
        sleep(2)
        task_list = all('tr')
        closest_deadline = task_list[1]
        expect(closest_deadline).to have_content 'task'
      end
    end
    context '優先順位が高い順に並んでいる場合' do
      it '優先度の高が一番上に表示される' do
        FactoryBot.create(:second_task, priority: 3)
        visit tasks_path
        click_on '優先度'
        sleep(2)
        priority = all('tr')
        high_priority = priority[1]
        expect(high_priority).to have_content '高'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        task_a = FactoryBot.create(:task, title: 'task_a')
        visit task_path(task_a)
        expect(page).to have_content 'task_a'
      end
    end
  end
end
