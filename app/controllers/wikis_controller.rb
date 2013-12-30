class WikisController < ApplicationController
  include WikiRunners

  def index
    run(Index) do |on|
      on.success { |wikis|
        @wikis = wikis
      }
    end
  end

  def show
    @wiki = run(Show, params[:id]).first
  end

  def new
    @wiki = run(New).first
  end

  def create
    run(Create, wiki_params) do |on|
      on.success { |wiki|
        redirect_to wikis_path, notice: "Wiki #{wiki.name} created"
      }
      on.failure { |wiki|
        @wiki = wiki
        render :new
      }
    end
  end

  def edit
    @wiki = run(Edit, params[:id])
  end

  def update
    run(Update, params[:id]) do |on|
      on.success { |wiki|
        redirect_to wikis_path, notice: "Wiki #{wiki.name} updated"
      }
      on.failure { |wiki|
        @wiki = wiki
        render :edit
      }
    end
  end

  def destroy
    wiki_name = run(Destroy, params[:id]).first
    redirect_to wikis_path, notice: "Wiki #{wiki_name} deleted"
  end

  private

  def wiki_params
    params.require(:wiki).permit(:name, :home_page)
  end
end
