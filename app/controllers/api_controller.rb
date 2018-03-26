class ApiController < ActionController::Base
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!

  def authenticate_user_from_token!
    if params[:auth_token].present?
      user = User.find_by_authentication_token(params[:auth_token])

      # sign_in 是 Devise 提供的
      sign_in(user, store: false) if user
    end
  end

end
