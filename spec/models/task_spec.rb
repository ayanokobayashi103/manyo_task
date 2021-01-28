require 'rails_helper'
describe 'タスクモデル機能', type: :model do
  before do
    @user = FactoryBot.create(:admin_user)
  end
  describe '検索機能' do
    let!(:task) { FactoryBot.create(:task, title: 'task', user: @user) }
    let!(:second_task) { FactoryBot.create(:second_task, user: @user) }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索キーワードを含むタスクが絞り込まれる" do
        expect(Task.title_search('task')).to include(task)
        expect(Task.title_search('task')).not_to include(second_task)
        expect(Task.title_search('task').count).to eq 1
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        status = Task.status_search(2)
        expect(status).to include(task)
        expect(status).not_to include("second_task")
        expect(status.count).to eq 1
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        third_task = FactoryBot.create(:third_task, title: 'task', user: @user)
        title_and_status = Task.status_search(1).title_search('task')
        expect(title_and_status).to include(third_task)
        expect(title_and_status.count).to eq 1
      end
    end
  end
  
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(title: '', content: '失敗テスト')
        expect(task).not_to be_valid
      end
    end
    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(title: '失敗テスト', content: '')
        expect(task).not_to be_valid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        task = Task.new(title: 'パステスト', content: 'パステスト')
        expect(task).to be_valid
      end
    end
  end
end
