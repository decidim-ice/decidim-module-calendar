# frozen_string_literal: true

module Decidim
  # Holds decidim-calendar version
  module Calendar
    DECIDIM_VERSION = "0.30.0"
    COMPAT_DECIDIM_VERSION = [">= 0.30", "< 0.31"].freeze

    def self.version
      "0.30.0"
    end
  end
end
