class MenuItem

  def initialize(title, uri, opts = {}, &block)
    @title = title
    @uri = uri
    @group = opts.delete(:group)
    @other_matches = {}
    [:get, :post, :put, :delete].each do |k|
      @other_matches[k] = opts[k] if opts[k]
    end

    @kids = []
    opts[:parent].try(:insert!, self)

    yield(self) if block_given?
  end

  attr_reader :parent, :title, :uri, :other_matches
  attr_writer :group

  def add(title, uri, opts = {}, &block)
    self.class.new(title, uri, opts.merge(:parent => self), &block)
  end

  def insert!(menu_item)
    raise ArgumentError, "Must be a #{self.class}" unless menu_item.is_a?(self.class)
    menu_item.instance_variable_set(:@parent, self)
    menu_item.group = @kids_group if @kids_group
    @kids << menu_item
  end

  def group(name = nil, &block)
    if name
      if block_given?
        @kids_group = name
        yield
        @kids_group = nil
      end
    else
      @group
    end
  end

  def root?
    !parent
  end

  ##################################################

  def children
    Subset.new(@kids.dup)
  end

  def path
    Subset.new(ancestors << self)
  end

  def ancestors
    Subset.new(root? ? [] : (parent.ancestors << parent))
  end

  def descendants
    d = []
    @kids.each { |k| d += k.descendants.unshift(k) }
    Subset.new(d)
  end

  def subtree
    Subset.new(descendants.unshift(self))
  end

  ##################################################
  private

  class Subset < BasicObject
    def initialize(ary)
      @ary = ary
    end

    def where(opts = {})
      select do |mi|
        opts.all? do |k, v|
          if v.is_a?(::Regexp)
            mi.send(k) =~ v
          else
            mi.send(k) == v
          end
        end
      end
    end

    def find_current(uri, request_method)
      request_method = request_method.downcase.to_sym
      reverse.find do |mi|
        mi.uri == uri || mi.other_matches.to_a.any? do |ary|
          ary[0] == request_method && ary[1] == uri
        end
      end
    end

    private

    def method_missing(method, *args, &block)
      @ary.send(method, *args, &block)
    end
  end

end