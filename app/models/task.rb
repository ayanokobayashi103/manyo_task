class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 50 }

  enum status:{未着手:0, 着手中:1, 完了:2}
  enum priority:{ 低:1, 中:2, 高:3}

  scope :created_sort, -> { order(created_at: :desc) }
  scope :deadline_sort, -> { order(deadline: :asc) }
  scope :priority_sort, -> { order(priority: :desc) }
  scope :title_search, -> (search) { where('title LIKE ?',"%#{search}%")}
  scope :status_search, -> (status) { where(status: status) }
  
end
