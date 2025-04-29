# frozen_string_literal: true

module Decidim
  # Holds decidim-calendar version
  module Calendar
    DECIDIM_VERSION = "0.29.3"
    COMPAT_DECIDIM_VERSION = [">= 0.29.2", "< 0.30"].freeze

    def self.version
      "0.29.0"
    end
  end
end
