class User < ApplicationRecord
  before_destroy :admin_lastone_destroy
  after_save :admin_lastone_save
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true,
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length:{ minimum: 6 }
  has_many :tasks, dependent: :destroy

  private
  def admin_lastone_destroy
    # 残りの管理者が1人、もしくは1人以下かつ、送られてきた削除する値が管理者だった場合以下実行
    if User.where(admin: true).count <= 1 && self.admin == true
      throw :abort
    end
  end

  def admin_lastone_save
    # 残りの管理者が1人になったかつ、変更する値が管理者ではない(なくなる)場合
    if User.where(admin: true).count == 0 && self.admin == false
      errors.add(:admin, ": 管理者がいなくなってしまいます")
      raise ActiveRecord::RecordInvalid, self
    end
  end
end
