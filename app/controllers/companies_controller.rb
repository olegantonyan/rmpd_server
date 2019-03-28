class CompaniesController < ApplicationController
  def index
    @companies = policy_scope(Company.includes(:user_company_memberships, :users, :invites)).order(created_at: :desc)
    authorize(@companies)
  end

  def show
    authorize(@company)
  end

  def new
    @company = Company.new
    authorize(@company)
  end

  def edit
    @company = Company.find(params[:id])
    authorize(@company)
  end

  def create # rubocop: disable Metrics/AbcSize
    @company = Company.new(company_params)
    @company.users = [current_user] unless current_user.root?
    authorize(@company)

    if @company.save
      flash[:success] = t('views.companies.save_successfull')
      redirect_to(companies_path)
    else
      flash[:error] = @company.errors.full_messages.to_sentence
      render(:new)
    end
  end

  def update # rubocop: disable Metrics/AbcSize
    @company = Company.find(params[:id])
    authorize(@company)

    if @company.update(company_params)
      flash[:success] = t('views.companies.save_successfull')
      redirect_to(companies_path)
    else
      flash[:error] = @company.errors.full_messages.to_sentence
      render(:edit)
    end
  end

  def destroy # rubocop: disable Metrics/AbcSize
    @company = Company.find(params[:id])
    authorize(@company)

    if @company.destroy
      flash[:success] = t('views.companies.successfully_deleted')
      redirect_to(companies_path)
    else
      flash[:alert] = @company.errors.full_messages.to_sentence
      redirect_to(edit_company_path(@company))
    end
  end

  def leave
    @company = Company.find(params[:id])
    authorize(@company)
    _srv = Company::Leave.new(user: current_user, company: @company)
  end

  private

  def company_params
    params.require(:company).permit(policy(:company).permitted_attributes)
  end
end
