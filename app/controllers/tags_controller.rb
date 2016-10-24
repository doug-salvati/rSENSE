class TagsController < ApplicationController
  skip_before_filter :authorize, only: [:enter, :clear]

  def create
    @tag = Tag.new(tag_params)

    unless can_edit?(@tag.project)
      flash[:error] = 'Action Not Authorized'
      redirect_to @tag.project
      return
    end

    if can_edit?(@tag.project) && @tag.save
      flash[:notice] = 'Added tag.'
      redirect_to [:edit, @tag.project]
    else
      @project = @tag.project

      @new_tag = ContribKey.new
      @new_tag.project_id = @project.id

      @errors = @tag.errors

      flash[:error] = 'Failed to create tag'
      render 'app/views/projects/_form.html.erb'
    end
  end

  def destroy
    @tag = Tag.find(params[:id])

    if can_edit?(@tag.project)
      @tag.destroy
      flash[:notice] = 'Deleted tag.'
      redirect_to [:edit, @tag.project]
    else
      flash[:error] = 'Action Not Authorized'
      redirect_to @tag.project
    end
  end

def enter
    @project = Project.find(params[:project_id])
    tags = @project.tags.where(tag: params[:tag].downcase)
    contributor_name = params[:contributor_name].to_s.strip

    if keys.count > 0 && contributor_name.length > 0
      session[:key] = keys.first.name
      session[:contrib_access] = @project.id
      session[:contributor_name] = params[:contributor_name]
      flash[:notice] = 'You have entered a valid tag.'
    elsif !(keys.count > 0) && contributor_name.length == 0
      flash[:error] = 'Invalid tag.', 'Enter a contributor Name.'
    elsif !(keys.count > 0)
      flash[:error] = 'Invalid tag.'
    elsif contributor_name.length == 0
      flash[:error] = 'Enter a contributor Name.'
    end

    redirect_to @project
  end

  def clear
    session[:contrib_access] = nil
    flash[:notice] = 'Your have cleared your contributor key.'
    if params[:project_id]
      redirect_to Project.find(params[:project_id])
    else
      redirect_to projects_path
    end
  end

  private

  def tag_params
    params[:tag].permit(:name, :project_id)
  end
end
