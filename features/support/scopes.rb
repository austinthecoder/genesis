module ScopeHelpers
  def scope_to(scope_str)
    case scope_str

    when "the fields table"
      "table.fields"

    when "the sidebar"
      "#sidebar"

    when "the templates"
      ".templates"

    when "the template form"
      "form.template"

    when "the name input"
      ".name.input"

    when /the row for the field with the name "([^"]*)"/
      fields = Field.where(:name => $1)
      field = case fields.size
        when 0
          raise "There are no fields with the name #{$1.inspect}"
        when 1
          fields.first
        else
          raise "There is more than one field with the name #{$1.inspect}"
      end
      "tr#field_#{field.id}"

    else
      raise <<-EOS
Can't find mapping from "#{scope_str}" to a scope.
Now, go and add a mapping in #{__FILE__}
      EOS
    end
  end
end

World(ScopeHelpers)