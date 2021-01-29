FactoryBot.define do
  factory :task do
    title { 'Factoryで作ったデフォルトのタイトル１' }
    content { 'Factoryで作ったデフォルトのコンテント１' }
    status {2}
    priority {1}
  end
  factory :second_task, class: Task do
    title { 'sample' }
    content { 'Factoryで作ったデフォルトのコンテントnewest' }
    priority {3}
    deadline {Time.current + 3.days }
  end
  factory :third_task, class: Task do
    title { 'Factoryで作ったデフォルトのタイトル3' }
    content { 'Factoryで作ったデフォルトのコンテント3' }
    status {1}
    deadline {Time.current + 3.days }
  end

end
