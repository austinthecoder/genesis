module AdminHelper

  class Link
    def initialize(title, path, other_matches = {})
      @title = title
      @path = path
      @other_matches = other_matches
    end

    attr_reader :title, :path, :other_matches
  end

  def Link(title, path, other_matches = {})
    Link.new(title, path, other_matches)
  end

  def main_menus
    @main_menus ||= nav_tree.children
  end

  def crumbs_menu_link
    @crumbs_menu_link ||= current_menu.ancestors.map(&:object)
  end

  def current_menus
    @current_menus ||= current_menu.children
  end

  def current_menu
    @current_menu ||= nav_tree.subtree.reverse.find do |t|
      t.object.path == current_path || t.object.other_matches.to_a.any? do |ary|
        ary[0] == request.request_method.downcase.to_sym && ary[1] == current_path
      end
    end
  end

  def current_path
    request.path
  end

  def nav_tree
    @nav_tree ||= BasicTree.new Link("Dashboard", admin_root_path) do |t|
      t.add Link("Pages", admin_pages_path) do |t|
        t.add Link("New Page", new_admin_page_path, :post => admin_pages_path)
        if @parent_page
          t.add Link("#{@parent_page.title}", edit_admin_page_path(@parent_page)) do |t|
            t.add Link("New Page", new_admin_page_page_path(@parent_page), :post =>  admin_page_pages_path(@parent_page))
          end
        elsif @page && !@page.new_record?
          t.add Link("#{@page.title_was}", edit_admin_page_path(@page), :put => admin_page_path(@page)) do |t|
            t.add Link("Change Template", edit_template_admin_page_path(@page))
          end
        end
      end

      t.add Link("Theme", admin_theme_path) do |t|
        t.add Link("Add a template", new_admin_template_path, :post => admin_templates_path)
        if @tpl && !@tpl.new_record?
          t.add Link("Template :: #{@tpl.name_was}", edit_admin_template_path(@tpl)) do |t|
            t.add Link("Template data", admin_template_fields_path(@tpl)) do |t|
              if @field && !@field.new_record?
                t.add Link(@field.name_was, edit_admin_field_path(@field), :put => admin_field_path(@field))
              end
            end
          end
        end
      end

      t.add Link("My Profile", edit_user_registration_path)
    end
  end

  def button_to(name, options = {}, html_options = {})
    html_options = html_options.stringify_keys
    convert_boolean_attributes!(html_options, %w( disabled ))

    method_tag = ''
    if (method = html_options.delete('method')) && %w{put delete}.include?(method.to_s)
      method_tag = tag('input', :type => 'hidden', :name => '_method', :value => method.to_s)
    end

    form_method = method.to_s == 'get' ? 'get' : 'post'

    remote = html_options.delete('remote')

    request_token_tag = ''
    if form_method == 'post' && protect_against_forgery?
      request_token_tag = tag(:input, :type => "hidden", :name => request_forgery_protection_token.to_s, :value => form_authenticity_token)
    end

    url = options.is_a?(String) ? options : self.url_for(options)
    name ||= url

    html_options = convert_options_to_data_attributes(options, html_options)

    html_options.merge!("type" => "submit")

    <<-HTML.strip_heredoc.html_safe
      <form method="#{form_method}" action="#{html_escape(url)}" #{'data-remote="true"' if remote} class="button_to">
        <div>
          #{method_tag}
          #{request_token_tag}
          #{content_tag(:button, name, html_options)}
        </div>
      </form>
    HTML
  end

end