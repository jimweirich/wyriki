class PagesController < ApplicationController

  def show
    wiki_id = params[:wiki_id]
    page_id = params[:id]
    run(PageRunners::Show, wiki_id, page_id) do |on|
      on.success { |wiki, page|
        @wiki = wiki
        @page = page
      }
    end
  end

  def show_named
    run(PageRunners::ShowNamed, named_params[:wiki], named_params[:page]) do |on|
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
    run(PageRunners::NewNamed, named_params[:wiki], named_params[:page]) do |on|
      on.success { |wiki, page|
        @wiki = wiki
        @page = page
        render :new
      }
    end
  end

  def new
    run(PageRunners::New, params[:wiki_id], params[:name]) do |on|
      on.success { |wiki, page|
        @wiki = wiki
        @page = page
      }
    end
  end

  def create
    run(PageRunners::Create, params[:wiki_id], page_params) do |on|
      on.success { |page|
        redirect_to [page.wiki, page], notice: "#{page.name} created"
      }
      on.failure { |wiki, page|
        render :new
      }
    end
  end

  def edit
    wiki_id = params[:wiki_id]
    page_id = params[:id]
    run(PageRunners::Edit, wiki_id, page_id) do |on|
      on.success { |wiki, page|
        @wiki = wiki
        @page = page
      }
    end
  end

  def update
    run(PageRunners::Update,
        params[:wiki_id], params[:id], content_params
      ) do |on|
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
    run(PageRunners::Destroy, params[:wiki_id], params[:id]) do |on|
      on.success { |wiki|
        redirect_to wiki
      }
    end
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
