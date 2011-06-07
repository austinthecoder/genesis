module AdminHelper

  def javascripts
    [
      'json2', # required for backbone
      'jquery', # required for backbone
      'underscore', # required for backbone
      'backbone', # see http://documentcloud.github.com/backbone
      'codemirror',
      'codemirror/mode/javascript/javascript',
      'codemirror/mode/css/css',
      'codemirror/mode/xml/xml',
      'codemirror/mode/htmlmixed/htmlmixed',
      'base' # application specific code
    ].map { |f| "admin/#{f}" }
  end

  def main_menu
    @main_menu ||= root_menu_item.children.where(:group => :main_menu)
  end

  def crumbs
    @crumbs ||= current_menu_item.ancestors
  end

  def current_menu
    @current_menu ||= current_menu_item.children
  end

  def current_menu_item
    @current_menu_item ||= root_menu_item.subtree.find_current(request.path, request.request_method)
  end

  def root_menu_item
    @root_menu_item ||= MenuItem.new "Dashboard", admin_root_path do |mi|

      mi.group :main_menu do
        mi.add "Pages", admin_pages_path do |mi|
          mi.add "New Page", new_admin_page_path, :post => admin_pages_path
          if @parent_page
            mi.add "#{@parent_page.title}", edit_admin_page_path(@parent_page) do |mi|
              mi.add "New Page", new_admin_page_page_path(@parent_page),
                :post =>  admin_page_pages_path(@parent_page)
            end
          elsif @page && !@page.new_record?
            mi.add "#{@page.title_was}", edit_admin_page_path(@page), :put => admin_page_path(@page) do |mi|
              mi.add "Change Template", edit_template_admin_page_path(@page)
            end
          end
        end

        mi.add "Theme", admin_theme_path do |mi|
          mi.add "Add a template", new_admin_template_path, :post => admin_templates_path
          if @tpl && !@tpl.new_record?
            mi.add "Template :: #{@tpl.name_was}", edit_admin_template_path(@tpl) do |mi|
              mi.add "Template data", admin_template_fields_path(@tpl) do |mi|
                if @field && !@field.new_record?
                  mi.add @field.name_was, edit_admin_field_path(@field), :put => admin_field_path(@field)
                end
              end
            end
          end
        end
      end

      mi.add "My Profile", edit_user_registration_path
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