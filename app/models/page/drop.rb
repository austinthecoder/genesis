class Page
  class Drop < Liquid::Drop

    include Comparable

    def initialize(page)
      raise(ArgumentError, "#{page.inspect} must be a Page") unless page.is_a?(Page)
      @page = page
      super
    end

    attr_reader :page

    def invoke_drop(method_or_key)
      contents.key?(method_or_key) ? contents[method_or_key] : super
    end

    alias :[] :invoke_drop

    def <=>(other)
      @page <=> other.page
    end

    private

    def contents
      unless defined?(@contents)
        @contents = {'Title' => @page.title}
        @page.contents.active.each do |c|
          @contents[c.field.name.titleize] = c.body
        end
      end
      @contents
    end
  end
end