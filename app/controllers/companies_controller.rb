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

  def create
    @company = Company.new(company_params)
    @company.users = [current_user] unless current_user.root?
    authorize(@company)
  end

  def update
    @company = Company.find(params[:id])
    authorize(@company)
  end

  def destroy
    @company = Company.find(params[:id])
    authorize(@company)
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
