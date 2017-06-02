class UsersController < BaseController
  include Filterrificable

  before_action :set_user, only: %i[show edit update destroy]

  # rubocop: disable Metrics/AbcSize, Style/Semicolon
  def index
    @filterrific = initialize_filterrific(
      User,
      params[:filterrific],
      select_options: {
        with_company_id: policy_scope(Company.all).map { |e| [e.to_s, e.id] }
      }
    ) || (on_reset; return)
    @users = policy_scope(@filterrific.find.page(page).per_page(per_page)).order(created_at: :desc)
    authorize @users
  end
  # rubocop: enable Metrics/AbcSize, Style/Semicolon

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    @user.assign_attributes(user_params)
    crud_respond @user, success_url: user_path(@user)
  end

  def destroy
    authorize @user
    crud_respond @user, success_url: users_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(policy(@user).permitted_attributes)
  end
end
