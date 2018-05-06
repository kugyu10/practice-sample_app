class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name,  presence: true,
                    length: { maximum: 50, minimum: 6}
                    
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255, minimum: 6},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false }
                    
  validates :password,  presence: true,
                        length: { maxlamum: 50, minimum: 8},
                        allow_nil: true

  has_secure_password
  
  def remember
    #self.remember_tokenに入れるのは、コントローラーでも使いたいから
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # 渡されたトークンがrememberダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # 特異クラス定義
  class << self 
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
  
end
