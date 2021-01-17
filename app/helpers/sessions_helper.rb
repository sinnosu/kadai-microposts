module SessionsHelper
  def current_user
    # current_userインスタンスに何も値が入っていなかったらfind_byで取得
    # 値が設定されているのにDB検索はナンセンスだからこういう処理
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    # current_userに値が入っていればtrue,なければfalse
    !!current_user
  end
end
