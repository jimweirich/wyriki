class PagesController < ApplicationController

  def show
    @wiki = Wiki.find(params[:wiki_id])
    @page = @wiki.pages.find(params[:id])
  end

  def new
    @wiki = Wiki.find(params[:wiki_id])
    @page = @wiki.pages.new
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
end
