require 'rails_helper'
RSpec.describe 'Label', type: :system do
  before do
    @user = FactoryBot.create(:admin_user)
    visit new_session_path
    fill_in 'session[email]', with:'admin@a.com'
    fill_in 'session[password]', with:'adminpass'
    click_on 'Log in'
    @label = FactoryBot.create(:label)
    @label2 = FactoryBot.create(:label2)
    @task = FactoryBot.create(:task,user: @user)
    @second_task = FactoryBot.create(:second_task,user: @user)
    FactoryBot.create(:labelling,task: @task,label: @label)
    FactoryBot.create(:labelling,task: @second_task,label: @label2)
  end
    describe '検索機能' do
    context '新規作成画面でラベルを複数選択できるか' do
      it "showに登録したラベルが表示される" do
        visit new_task_path
        fill_in 'task[title]', with:'task_title'
        fill_in 'task[content]', with:'task_content'
        check 'ラベル1'
        check 'ラベル2'
        click_on '登録する'
        label_list = all("tr")
        sleep(1)
        label_list = label_list[3]
        expect(label_list).to have_content'ラベル1'
        expect(label_list).to have_content'ラベル2'
        expect(label_list).not_to have_content 'ラベル3'
      end
    end
    context '編集画面でラベルを変更できるか' do
      it "showに解除したラベルが表示されない" do
        visit tasks_path
        page.all("#edit_link")[0].click
        uncheck 'ラベル1'
        check 'ラベル2'
        click_on '更新する'
        label_list = all("tr")
        sleep(1)
        label_list = label_list[1]
        expect(label_list).to have_content'ラベル2'
        expect(label_list).not_to have_content 'ラベル1'
      end
    end
    context 'ラベルで検索ができるか' do
      it "indexに解除したラベルが表示されない" do
        visit tasks_path
        select "ラベル1", from: "label_id"
        find("#label_search").click
        label_list = all("tr")
        sleep(1)
        label_1 = label_list[1]
        expect(label_1).to have_content'ラベル1'
        expect(label_1).not_to have_content 'ラベル2'
      end
    end
  end
end
