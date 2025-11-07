class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  before_action :set_user, only: [:show]

  def show
    # Make sure devise mapping is set
    self.resource = current_user
  end

  protected

  def after_update_path_for(resource)
    user_profile_path
  end

  private

  def set_user
    @user = current_user
  end
end
