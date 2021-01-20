class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 50 }

  enum status:{未着手:0, 着手中:1, 完了:2}

  scope :created_sort, -> { order(created_at: :desc) }
  scope :deadline_sort, -> { order(deadline: :asc) }
  scope :title_search, -> (search) { where('title LIKE ?',"%#{search}%")}
  scope :status_search, -> (status) { where(status: status) }
  #scope :title_status_search, ->status,search { status_search(status).title_search(search) }

end
