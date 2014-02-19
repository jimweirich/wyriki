require_dependency './app/models/biz/model'

module Biz
  class Wiki < Model

    # Is the page in the defined in the repository?
    def page?(repo, page_name)
      page = repo.find_named_page(data.name, page_name)
      ! page.nil?
    end
  end
end
