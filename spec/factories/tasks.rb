FactoryBot.define do
  factory :task do
    title { 'Factoryで作ったデフォルトのタイトル１' }
    content { 'Factoryで作ったデフォルトのコンテント１' }
  end
  factory :second_task, class: Task do
    title { 'Factoryで作ったデフォルトのタイトルnewest' }
    content { 'Factoryで作ったデフォルトのコンテントnewest' }
  end
  factory :third_task, class: Task do
    title { 'Factoryで作ったデフォルトのタイトル3' }
    content { 'Factoryで作ったデフォルトのコンテント3' }
  end

end
