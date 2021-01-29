class User < ApplicationRecord
  before_destroy :admin_lastone_destroy
  after_save :admin_lastone_save
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true,
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length:{ minimum: 6 }, on: :create
  has_many :tasks, dependent: :destroy
  has_many :labels, dependent: :destroy

  private
  def admin_lastone_destroy
    if User.where(admin: true).count <= 1 && self.admin == true
      throw :abort
    end
  end

  def admin_lastone_save
    if User.where(admin: true).count == 0 && self.admin == false
      errors.add(:admin, ": 管理者がいなくなってしまいます")
      raise ActiveRecord::RecordInvalid
    end
  end
end
