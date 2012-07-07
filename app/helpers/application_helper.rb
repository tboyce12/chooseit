module ApplicationHelper
  def user_omniauth_signed_in?
    (current_user && current_user.provider) ? true : false
  end
end
