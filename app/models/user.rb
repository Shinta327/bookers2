class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # relationshipの関連付け(active_relationshipはここで名前を定義している。クラスの参照はRekationshipで外部キーがfollower_idになっている)
  # ユーザーはactive_relationship、つまり自分からのフォローをたくさん持っている状態
  # 外部キーのfollowerはユーザーに対してフォローしている人を指す。ユーザーAがB・C・Dをフォローしている場合、B・C・Dは　followed_id、Aが外部キーのfollower_idとなる。
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy

   # 受動的関係、自分（ユーザーA）をフォローしている人たちについて定義する
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent: :destroy

  # ユーザーAはactive_relatinshipsテーブルを通してたくさんのフォローしている人たち（followeds = following）をもっている。
  # followedsでは英語的におかしいのでfollowingという名前をあたえsourceの部分で参照するカラム名を指定している。
  has_many :following, through: :active_relationships, source: :followed

  # ユーザーは多数のフォローされている人たちをもつ
  has_many :followers, through: :passive_relationships, source: :follower

  # コントローラーではなくモデルにメソッドを記載する
  # <<でfollowingつまりユーザーAがフォローしている人たちの配列にother_userを追加する。
  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end


  attachment :profile_image

  validates :name, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }
end
