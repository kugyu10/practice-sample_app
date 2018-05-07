module SessionsHelper
  
  # 渡されたユーザーをログイン状態にする
  def log_in(user)
    session[:user_id] = user.id
  end
 
  # 渡されたユーザーがログインユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  # 記憶トークン(cookie)に対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember #new_tokenを新しく作って仮想属性に保存
    cookies.permanent.signed[:user_id] = user.id 
    cookies.permanent[:remember_token] = user.remember_token 
  end
  
  # Remember me の逆
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # 今のURLをフォワード先URLとして覚えておく  
  def store_forwarding_url
    session[:forwarding_url] = request.original_url if request.get?
  end
end
