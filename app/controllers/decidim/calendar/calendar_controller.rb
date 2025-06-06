# frozen_string_literal: true

module Decidim
  module Calendar
    class CalendarController < Decidim::Calendar::ApplicationController
      helper Decidim::Calendar::CalendarHelper
      include Decidim::Calendar::CalendarHelper
      layout "calendar"

      helper_method :tasks

      def index
        @events = Event.all(current_organization)
      end

      def gantt
        @events = Decidim::ParticipatoryProcessStep.where.not(start_date: nil).order(decidim_participatory_process_id: :asc, position: :asc, start_date: :asc).map do |p|
          Decidim::Calendar::EventPresenter.new(p) if p.organization == current_organization
        end
      end

      def ical
        filename = "#{current_organization.name[current_organization.default_locale.to_s].parameterize}-calendar"
        response.headers["Content-Disposition"] = "attachment; filename=#{filename}.ical"
        render plain: GeneralCalendar.for(current_organization), content_type: "text/calendar"
      end

      private

      def tasks
        @tasks ||= @events.map { |space| participatory_gantt(space) }
      end
    end
  end
end
