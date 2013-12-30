class PagesController < ApplicationController

  def show
    wiki_id = params[:wiki_id]
    page_id = params[:id]
    run(PageRunners::Show, wiki_id, page_id,
      success: ->(wiki, page) {
        @wiki = wiki
        @page = page
      })
  end

  def show_named
    run(PageRunners::ShowNamed, named_params[:wiki], named_params[:page],
      success: ->(wiki, page) {
        @wiki = wiki
        @page = page
        render :show
      },
      page_not_found: ->(wiki) {
        redirect_to new_named_page_path(wiki.name, named_params[:page])
      })
  end

  def new_named
    run(PageRunners::NewNamed, named_params[:wiki], named_params[:page],
      success: ->(wiki, page) {
        @wiki = wiki
        @page = page
        render :new
      })
  end

  def new
    run(PageRunners::New, params[:wiki_id], params[:name],
      success: ->(wiki, page) {
        @wiki = wiki
        @page = page
      })
  end

  def create
    run(PageRunners::Create,
      params[:wiki_id],
      page_params,
      success: ->(page) {
        redirect_to [page.wiki, page], notice: "#{page.name} created"
      },
      failure: ->(wiki, page) {
        render :new
      })
  end

  def edit
    wiki_id = params[:wiki_id]
    page_id = params[:id]
    run(PageRunners::Edit, wiki_id, page_id,
      success: ->(wiki, page) {
        @wiki = wiki
        @page = page
      })
  end

  def update
    run(PageRunners::Update, params[:wiki_id], params[:id],
      success: ->(wiki, page) {
        redirect_to [@wiki, @page], notice: "#{@page.name} updated"
      },
      failure: ->(wiki, page) {
        render :new
      })
  end

  def destroy
    run(PageRunners::Destroy, params[:wiki_id], params[:id],
      success: ->(wiki) {
        redirect_to wiki
      })
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
