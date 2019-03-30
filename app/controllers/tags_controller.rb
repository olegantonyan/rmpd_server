class TagsController < ApplicationController
  def index
    @tags = policy_scope(Tag.includes(:taggings)).order(name: :asc)
    authorize(@tags)
  end

  def edit
    @tag = Tag.find(params[:id])
    authorize(@tag)
  end

  def create
    @tag = Tag.new(tag_params)
    authorize(@tag)

    if @tag.save
      flash[:success] = t('views.tags.save_successfull')
    else
      flash[:error] = @tag.errors.full_messages.to_sentence
    end
    redirect_to(tags_path)
  end

  def update # rubocop: disable Metrics/AbcSize
    @tag = Tag.find(params[:id])
    authorize(@tag)

    if @tag.update(tag_params)
      flash[:success] = t('views.tags.save_successfull')
      redirect_to(tags_path)
    else
      flash[:error] = @tag.errors.full_messages.to_sentence
      render(:edit)
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    authorize(@tag)

    if @tag.destroy
      flash[:success] = t('views.tags.successfully_deleted')
    else
      flash[:alert] = @tag.errors.full_messages.to_sentence
    end
    redirect_to(tags_path)
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
