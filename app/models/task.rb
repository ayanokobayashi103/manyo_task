class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 50 }

  enum status:{未着手:0, 着手中:1, 完了:2}
end
