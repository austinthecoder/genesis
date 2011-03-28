module HtmlSelectorsHelpers
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)
    case locator

    when /the page$/ then "html > body"

    when "the fields table" then "table.fields"

    when "the sidebar" then "#sidebar"

    when "the templates" then ".templates"
    when "the template form" then "form.template"
    when /the row for (that template)/ then ".template_#{Transform($1).id}"

    when "the name input" then ".name.input"
    when "the title input" then ".title.input"
    when "the permalink input" then ".slug.input"

    when "the form" then "form"

    when "the list of pages" then ".pages"
    when /the page with the title "([^"]*)"/
      page = Page.find_by_title($1)
      "#page_#{page.id}"
    when /the row for (the "([^"]*)" page)/
      page = Transform($1)
      "#page_#{page.id}"
    when /the row for (that page)/ then
      page = Transform($1)
      "#page_#{page.id}"

    when "the fields" then ".fields"
    when /the row for (that field)/ then "#field_#{Transform($1).id}"
    when /the row for the "([^"]*)" field/
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

    when "the template section" then '.template'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #  when /the (notice|error|info) flash/
    #    ".flash.#{$1}"

    # You can also return an array to use a different selector
    # type, like:
    #
    #  when /the header/
    #    [:xpath, "//header"]

    # This allows you to provide a quoted selector as the scope
    # for "within" steps as was previously the default for the
    # web steps:
    when /"(.+)"/
      $1

    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelpers)