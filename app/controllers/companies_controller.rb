class CompaniesController < BaseController
  include Filterrificable

  before_action :set_company, only: %i(show edit update destroy leave)

  # rubocop: disable Style/Semicolon, Style/RedundantParentheses
  def index
    @filterrific = initialize_filterrific(
      Company,
      params[:filterrific]
    ) || (on_reset; return)
    filtered = @filterrific.find.page(page).per_page(per_page)
    @companies = policy_scope(filtered)
    authorize @companies
  end
  # rubocop: eanble Style/Semicolon, Style/RedundantParentheses

  def show
    authorize @company
  end

  def new
    @company = Company.new
    authorize @company
  end

  def edit
    authorize @company
  end

  def create
    @company = Company.new(company_params_for_create)
    authorize @company
    crud_respond @company
  end

  def update
    authorize @company
    @company.assign_attributes(company_params)
    crud_respond @company, success_url: company_path(@company)
  end

  def destroy
    authorize @company
    crud_respond @company
  end

  def leave
    authorize @company
    srv = Company::Leave.new(user: current_user, company: @company)
    crud_respond srv, error_url: company_path(@company)
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    if current_user&.root?
      params.require(:company).permit(:title, user_ids: [])
    else
      params.require(:company).permit(:title)
    end
  end

  def company_params_for_create
    c_params = company_params
    c_params[:user_ids] = [current_user.id] unless current_user.root?
    c_params
  end

  def crud_responder_default_options
    { success_url: companies_path }
  end
end
