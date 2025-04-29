# frozen_string_literal: true

require "spec_helper"

describe "manage external events" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:start_date) { Time.current.strftime("%d/%m/%Y") }
  let(:start_time) { Time.current.strftime("%H:%M") }
  let(:end_date) { 2.days.from_now.strftime("%d/%m/%Y") }
  let(:end_time) { 2.days.from_now.strftime("%H:%M") }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_calendar.external_events_path
  end

  describe "creating a event" do
    before do
      within ".item_show__header" do
        click_on "New external event"
      end
    end

    it "create a new external event" do
      within ".new_event" do
        fill_in_i18n(
          :external_event_title,
          "#external_event-title-tabs",
          en: "Example Event",
          es: "Evento de ejemplo",
          ca: "Evento de ejemplo"
        )

        fill_in_datepicker "external_event_start_at_date", with: start_date
        fill_in_timepicker "external_event_start_at_time", with: start_time
        fill_in_datepicker "external_event_end_at_date", with: end_date
        fill_in_timepicker "external_event_end_at_time", with: end_time

        fill_in :external_event_url, with: "https://example.org"

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within ".table-list" do
        expect(page).to have_css("td", text: "Example Event")
        expect(page).to have_css("td", text: "https://example.org")
      end
    end
  end

  describe "external event actions" do
    let!(:external_event) { create(:external_event, organization:) }

    before do
      visit current_path
    end

    it "delete a event" do
      within "tr", text: translated(external_event.title) do
        accept_confirm { click_on "Delete" }
      end

      expect(page).to have_admin_callout("successfully")

      within "#events" do
        expect(page).to have_no_content(translated(external_event.title))
      end
    end

    it "update a event" do
      within "tr", text: translated(external_event.title) do
        click_on "Edit"
      end

      fill_in_datepicker "external_event_start_at_date", with: start_date
      fill_in_timepicker "external_event_start_at_time", with: start_time
      fill_in_datepicker "external_event_end_at_date", with: end_date
      fill_in_timepicker "external_event_end_at_time", with: end_time

      within ".edit_event" do
        fill_in_i18n(
          :external_event_title,
          "#external_event-title-tabs",
          en: "Edited Example Event",
          es: "Edited Evento de ejemplo",
          ca: "Edited Evento de ejemplo"
        )
        fill_in :external_event_url, with: "https://example.org"

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")
      within "#events" do
        expect(page).to have_content("Edited Example Event")
      end
    end
  end
end
