class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      forwarding_url = session[:forwarding_url]
      reset_session      # ログインの直前に必ずこれを書くこと
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember user
      log_in user
      redirect_to forwarding_url || user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
