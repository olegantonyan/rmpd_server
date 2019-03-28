class UsersController < ApplicationController
  def index
    @users = policy_scope(User.includes(:companies)).order(created_at: :desc)
    authorize(@users)
  end

  def show
    @user = User.find(params[:id])
    authorize(@user)
  end

  def destroy # rubocop: disable Metrics/AbcSize
    @user = User.find(params[:id])
    authorize(@user)

    if @user.destroy
      flash[:success] = t('views.users.successfully_deleted')
      redirect_to(users_path)
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      redirect_to(user_path(@user))
    end
  end
end
