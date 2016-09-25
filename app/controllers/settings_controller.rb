class SettingsController < ApplicationController

  expose(:setting) { Setting.find_by_user_id(current_user.id) }

  def update
    if setting.update(setting_params)
      redirect_to settings_path
    else
      render :index
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:hide_show_answers_button)
  end
end
