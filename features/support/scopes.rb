module ScopeHelpers
  def scope_to(scope_str)
    case scope_str

    when "the sidebar"
      "#sidebar"

    when "the templates"
      ".templates"

    when "the template form"
      "form.template"

    when "the name input"
      ".name.input"

    else
      raise <<-EOS
Can't find mapping from "#{scope_str}" to a scope.
Now, go and add a mapping in #{__FILE__}
      EOS
    end
  end
end

World(ScopeHelpers)