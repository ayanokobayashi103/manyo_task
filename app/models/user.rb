class User < ApplicationRecord
  before_destroy :admin_destroy
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true,
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length:{ minimum: 6 }
  has_many :tasks, dependent: :destroy

  private
  def admin_destroy
    if admin?
      admin=User.where(admin:true)
      if admin.count > 0
        # errors.add(:admin, ": 管理者がいなくなってしまいます")
        # returnと言う意味
        throw :abort
      end
    end
  end
  
end
