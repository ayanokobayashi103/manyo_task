class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 50 }

  enum status:{未着手:0, 着手中:1, 完了:2}

  scope :created_sort, -> { order(created_at: :desc) }
  scope :deadline_sort, -> { order(deadline: :asc) }
  scope :title_sort, -> search { where('title LIKE ?',"%#{search}%")}
  scope :status_sort, -> (status) { where(status: status) }
  scope :search_status_sort, -> (task) { title_sort.status }

end
