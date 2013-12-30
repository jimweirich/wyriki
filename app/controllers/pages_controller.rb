class PagesController < ApplicationController
  include PageRunners

  def show
    @wiki, @page = run(Show, params[:wiki_id], params[:id])
  end

  def show_named
    run(ShowNamed, named_params[:wiki], named_params[:page]) do |on|
      on.success { |wiki, page|
        @wiki = wiki
        @page = page
        render :show
      }
      on.page_not_found { |wiki_name|
        redirect_to new_named_page_path(wiki_name, named_params[:page])
      }
    end
  end

  def new_named
    @wiki, @page = run(NewNamed, named_params[:wiki], named_params[:page])
    render :new
  end

  def new
    @wiki, @page = run(New, params[:wiki_id], params[:name])
  end

  def create
    run(Create, params[:wiki_id], page_params) do |on|
      on.success { |page|
        redirect_to [page.wiki, page], notice: "#{page.name} created"
      }
      on.failure { |wiki, page|
        render :new
      }
    end
  end

  def edit
    @wiki, @page = run(Edit, params[:wiki_id], params[:id])
  end

  def update
    run(Update, params[:wiki_id], params[:id], content_params ) do |on|
      on.success { |wiki, page|
        redirect_to [wiki, page], notice: "#{page.name} updated"
      }
      on.failure { |wiki, page|
        @wiki = wiki
        @page = page
        render :new
      }
    end
  end

  def destroy
    wiki = run(Destroy, params[:wiki_id], params[:id]).first
    redirect_to wiki
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
