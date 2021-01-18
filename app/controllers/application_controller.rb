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
  end
end
