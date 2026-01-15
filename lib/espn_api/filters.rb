require_relative "filters/player"
require_relative "filters/schedule"

module ESPNApi
  class Filters
    def initialize(*filters)
      @filters = filters&.map(&:to_h)&.reduce(&:merge) || {}
    end

    def to_h
      @filters
    end

    def to_json
      @filters.to_json
    end

    def +(other)
      Filters.new(self, other)
    end

    protected

    def section
      raise NotImplementedError, "Subclasses must define a section key"
    end

    def section_filters
      @filters[section] ||= {}
    end

    def add_filter(key, value)
      section_filters[key] = value
      self
    end

    def add_sort(key, ascending:, priority:, value: nil)
      sort_hash = { sortAsc: ascending, sortPriority: priority }
      sort_hash[:value] = value if value
      add_filter(key, sort_hash)
    end
  end
end
