class Page
  class Drop < Liquid::Drop
    def initialize(page)
      raise(ArgumentError, "#{page.inspect} must be a Page") unless page.is_a?(Page)
      @page = page
      super
    end

    attr_reader :page

    def before_method(method)
      contents[method]
    end

    def <=>(other)
      @page <=> other.page
    end

    private

    def contents
      @contents ||= {}.tap do |h|
        @page.contents.active.each do |c|
          h[c.field.name.titleize] = c.body
        end
      end
    end
  end
end