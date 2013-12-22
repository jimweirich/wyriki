class WikisController < ApplicationController

  def index
    @wikis = Wiki.active_wikis
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new(wiki_params)
    if @wiki.save
      redirect_to wikis_path, notice: "Wiki #{@wiki.name} created"
    else
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    if @wiki.update_attributes(wiki_params)
      redirect_to wikis_path, notice: "Wiki #{@wiki.name} updated"
    else
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    @wiki.destroy
    redirect_to wikis_path, notice: "Wiki #{@wiki.name} deleted"
  end

  private

  def wiki_params
    params.require(:wiki).permit(:name, :home_page)
  end
end
