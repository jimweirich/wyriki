module Attrs
  module_function

  ATTRIBUTES = {
    user: { name: "Jon Dough", email: "jon@jon", password: "secret", password_confirmation: "secret" },
    wiki: { name: "Wiki", home_page: "HomePage" },
    page: { name: "HomePage" },
    permission: { role: "writer" }
  }

  def method_missing(sym, *args, &block)
    attrs = ATTRIBUTES[sym]
    fail "No attributes given for '#{sym}'" if attrs.nil?
    args.first ? attrs.merge(args.first) : attrs
  end

end
