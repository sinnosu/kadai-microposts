class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
  private
  
  # 全てのコントローラ-アクションで使用できるようにこのクラスで定義する
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def counts(user)
    @count_microposts = user.microposts.count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
    @count_favorites = user.favors.count
  end
end
