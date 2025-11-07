class Users::PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_minimum_password_length, only: [:edit]

  layout 'application'

  def edit
    render template: 'users/passwords/edit'
  end

  def update
    if current_user.update_with_password(password_params)
      bypass_sign_in(current_user)
      redirect_to user_profile_path, notice: 'Password was successfully updated.'
    else
      set_minimum_password_length
      render :edit
    end
  end

  private

  def set_minimum_password_length
    @minimum_password_length = Devise.password_length.min
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
