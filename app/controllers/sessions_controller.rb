class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if login(email, password)
      flash[:success] = 'ログインに成功しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      # renderメソッドは文字列でもシンボルでもどっちでもよい
      # render "new"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
  
  private
  
  def login(email, password)
    # emailをキーにユーザ検索
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      # ログイン成功
      # 1.Userテーブルに該当するuser(id)が見つかった
      # 2.パスワードが一致した
      session[:user_id] = @user.id
      return true
    else
      # ログイン失敗
      return false
    end
  end
end
