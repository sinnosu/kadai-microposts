class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum:50 }
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }  
  
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  # お気に入り機能
  has_many :favorites
  has_many :favors, through: :favorites, source: :micropost
  has_many :reverses_of_favorite, class_name: 'Favorite', foreign_key: 'micropost_id'
  has_many :favored, through: :reverses_of_favorite, source: :user
  
  # フォロー処理
  def follow(other_user)
    # 自分自身はフォローしないよ
    unless self == other_user
      # すでに登録されていない場合は登録する。登録されていたらインスタンスを返却
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  # アンフォロー処理
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    # relationshipが存在していたら消す
    relationship.destroy if relationship
  end
  # フォロー確認
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  # タイムライン用のマイクロポストを取得する
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  # お気に入り登録
  def favorite(micropost)
    # すでに登録されていない場合は登録する。登録されていたらインスタンスを返却
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end
  # お気に入り解除
  def unfavorite(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  # お気に入り確認
  def favor?(micropost)
    self.favors.include?(micropost)
  end
end
