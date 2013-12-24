class PagesController < ApplicationController

  def show
    @wiki = Wiki.find(params[:wiki_id])
    @page = @wiki.pages.find(params[:id])
  end

  def show_named
    @page = Page.by_name(named_params[:wiki], named_params[:page])
    if @page
      render :show
    else
      wiki = Wiki.find_by_name(named_params[:wiki])
      redirect_to new_named_page_path(wiki.name, named_params[:page])
    end
  end

  def new_named
    @wiki = Wiki.find_by_name(named_params[:wiki])
    @page = @wiki.pages.new(name: named_params[:page])
    render :new
  end

  def new
    @wiki = Wiki.find(params[:wiki_id])
    @page = @wiki.pages.new(name: params[:name])
  end

  def create
    @wiki = Wiki.find(params[:wiki_id])
    @page = @wiki.pages.new(page_params)
    if @page.save
      redirect_to [@wiki, @page], notice: "#{@page.name} created"
    else
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:wiki_id])
    @page = @wiki.pages.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:wiki_id])
    @page = @wiki.pages.find(params[:id])
    if @page.update_attributes(content_params)
      redirect_to [@wiki, @page], notice: "#{@page.name} updated"
    else
      render :new
    end
  end

  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    @page = @wiki.pages.find(params[:id])
    @page.destroy
    redirect_to @wiki
  end

  private

  def page_params
    params.require(:page).permit(:name, :content)
  end

  def content_params
    params.require(:page).permit(:content)
  end

  def named_params
    params.require(:wiki)
    params.require(:page)
    params
  end
end
