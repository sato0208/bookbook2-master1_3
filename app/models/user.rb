class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # welcomeメールの送信
  # Userが新規作成された後にメールを送信するためのメソッドを呼び出す
  after_create :send_welcome_mail

  # 多数のbookと一つのuserを関連づけする

  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # プロフィール画像投稿できるようにする記述
  attachment :profile_image
  # 二文字以下、二十文字以上はバリデート
  validates :name, presence: true, length: {maximum: 10, minimum: 2}
  # 五十文字以上はバリデート
  validates :introduction, length:{ maximum: 50}

  # foregin_key = 入口
  # source = 出口

  # フォロー、フォロワー機能
  has_many :relationships, class_name: 'Relationship', foreign_key: 'user_id'

  # has_manyは上の一行と同じ
  # current_user.relationships
  # Relationship.where(user_id: current_user.id)
  # followingクラス（モデル）は今作った架空のものなので、補足を付け足す必要があります。
  # through: :relationships は「中間テーブルはrelationshipsだよ」って設定
  # source: :followは「relationshipsテーブルのfollow_idを参考にして、followingsモデルにアクセスしてね」って事
  # フォローしてる数
  has_many :followings, through: :relationships, source: :follow
  # has_many :reverse_of_relationshipsは
  # has_many :relaitonshipsの「逆方向」って意味

  # foreign_key: 'follow_id'は「relaitonshipsテーブルにアクセスする時、follow_idを入口として来てね！」
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  # フォローされている数
  has_many :followers, through: :reverse_of_relationships, source: :user

  def follow(other_user)
    # フォローしようとしている other_user が自分自身ではないかを検証
    unless self == other_user
      # selfには実行したUserが代入される。見つかれば Relation を返し、
      # 見つからなければフォロー関係を保存(create = new + save)する
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

# フォローがあればアンフォローする
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    # relationship が存在すれば destroy します
    relationship.destroy if relationship
  end

# self.followings によりフォローしている User 達を取得し、
# include?(other_user) によって other_user が含まれていないかを確認
  def following?(other_user)
    self.followings.include?(other_user)
  end

  def follows_by?(user)
    relationships.where(user_id: user.id).exists?
  end

  def User.search(search, user_or_book, how_search)
    if user_or_book == "1"
      if how_search == "1"
        User.where(['name LIKE ?', "%#{search}%"])
      elsif how_search == "2"
        User.where(['name LIKE ?', "%#{search}"])
      elsif how_search == "3"
        User.where(['name LIKE ?', "#{search}%"])
      elsif how_search == "4"
        User.where(['name LIKE ?', "#{search}"])
      else
        User.all
      end
    end
  end
  # 住所入力用
  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
# 地図表示用
    geocoded_by :address_city
  after_validation :geocode, if: :address_city_changed?
  # welcomeメールの送信
  def send_welcome_mail
    UserMailer.user_welcome_mail(self).deliver
  end
end
