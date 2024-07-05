# frozen_string_literal: true

require "spec_helper"

describe "View menus" do
  let!(:organization) { create(:organization) }
  let!(:participatory_process) { create(:participatory_process, :published, organization:) }
  let!(:menu_block) { create(:content_block, organization:, scope_name: :homepage, manifest_name: :global_menu) }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "has a global menu" do
    within "#home__menu" do
      expect(page).to have_content("Calendar")
    end
  end

  it "has a drawer menu" do
    click_on "Processes", match: :first
    within "#menu-bar" do
      expect(page).to have_css("a", text: "Calendar", visible: :all)
    end
  end
end
