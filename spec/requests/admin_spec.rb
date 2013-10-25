require 'spec_helper'

describe "Admin module", :js=>true do
  # include Warden::Test::Helpers
  # Warden.test_mode!
  sleep_time=1
  let(:domain) { create :domain, name: "test domain"}
  let(:game) { create :game, name: "test game", parent: domain }
  let(:task) { create :task, name: "test task", parent: game }
  let(:answer) { create :answer, parent: task, body: "answer", x: 100, y: 0 }
  let(:hint) { create :hint, parent: task, x: 0, y: 0 }

  # before { login_as(create(:root_user),scope: :user) }

  describe "router" do

    it 'routes to the parent and selects by id' do
      hint;answer
      visit admin_path parent_id: task.id, select_id: hint.id
      page.should have_no_selector(".block:contains('#{game.name}')")
      page.should have_selector(".block:contains('answer')")
      page.should have_selector(".block.ui-selected:contains('#{hint.body}')")
    end

    it 'changes the route & renders properties on the block selection' do
      hint;answer
      visit admin_path parent_id: task.id, select_id: hint.id
      find(".block:contains('answer')").click
      page.should have_selector(".block.ui-selected:contains('answer')")
      current_path.should eq(admin_path parent_id: task.id, select_id: answer.id) #TODO: https://github.com/thoughtbot/capybara-webkit/issues/296
      find("#properties").should have_content(t("admin.answer.tool"))
    end

    it 'selects parent on the select of several blocks (no tools)'

    it 'selects parent on the field click' do
      hint;answer
      visit admin_path parent_id: task.id, select_id: hint.id
      find("#field").click
      current_path.should eq(admin_path parent_id: task.id, select_id: 0)
      find("#properties").should have_content(t("admin.task.tool"))
    end

  end

  describe "toolbar" do

    it 'creates domain' do
      visit admin_path parent_id: 0, select_id: 0
      expect { find(".tool:contains('#{t("admin.domain.tool")}')").click; sleep(sleep_time) }.to change{ Domain.count }.by(1)
      page.should have_selector(".block:contains('#{t("admin.domain.new")}')")
    end

    it 'creates game' do
      visit admin_path parent_id: domain.id, select_id: 0
      expect { find(".tool:contains('#{t("admin.game.tool")}')").click; sleep(sleep_time) }.to change{ Game.count }.by(1)
      page.should have_selector(".block:contains('#{t("admin.game.new")}')")
    end

    it 'creates task' do
      visit admin_path parent_id: game.id, select_id: 0
      expect { find(".tool:contains('#{t("admin.task.tool")}')").click; sleep(sleep_time) }.to change{ Task.count }.by(1)
      page.should have_selector(".block:contains('#{t("admin.task.new")}')")
    end

  end

  describe "path" do

    it 'renders the path' do
      visit admin_path parent_id: task.id, select_id: 0
      path=find("#path")
      path.should have_content(t("admin.path.root"))
      path.should have_content(domain.name)
      path.should have_content(game.name)
      path.should have_content(task.name)
    end

    it 'routes to the parent on up-click' do
      visit admin_path parent_id: task.id, select_id: 0
      find("#path-container #lvl-up").click
      current_path.should eq(admin_path parent_id: game.id, select_id: 0)
    end

  end

  describe "field" do

    it 'changes scope on double click' do
      task
      visit admin_path parent_id: 0, select_id: 0
      double_click ".block:contains(\"#{domain.name}\")" #do not change quotes
      #wait_until(0.1) { find(".block:contains(\"#{game.name}\")") }
      sleep 0.1
      double_click ".block:contains(\"#{game.name}\")"
      sleep 0.1
      find("#toolbar").should have_content(t("admin.task.tool"))
      find("#path").should have_content(game.name)
      find("#field").should have_content(task.name)
      find("#properties").should have_content(t("admin.game.tool"))
    end

    it 'reloads the field' do
      visit admin_path parent_id: 0, select_id: 0
      find("#field").should have_no_content("test domain")
      domain
      find("#field #refresh").click
      sleep 0.1
      find("#field").should have_content("test domain")
    end

    it 'destroys blocks on backspace/delete'
    it 'destroys block on x click'

    #no tools
    it 'moves on up-down-left-right keys (no tools)'
    it 'moves on drag (no tools)'
    it 'creates relation (no tools)'#, driver: :selenium do
    #   answer;hint
    #   visit admin_path parent_id: task.id, select_id: 0
    #   sleep 1
    #   expect { first("._jsPlumb_endpoint").drag_to(all("._jsPlumb_endpoint")[1]); sleep(7) }.to change{ Relation.count }.by(1)
    # end
  end

  describe "properties" do

    it 'saves changes on click save' do
      visit admin_path parent_id: game.id, select_id: task.id
      within("#properties-container") do
        fill_in 'name', with: "test name"
        click_button t("admin.links.save")
      end
      sleep 0.1
      task.reload.name.should eq("test name")
    end

    it 'saves changes on click field' do
      visit admin_path parent_id: game.id, select_id: task.id
      within("#properties-container") do
        fill_in 'name', with: "test name"
      end
      find("#field").click
      sleep 0.1
      task.reload.name.should eq("test name")
    end

    it 'saves changes on click other block' do
      hint
      visit admin_path parent_id: task.id, select_id: answer.id
      within("#properties-container") do
        fill_in 'body', with: "test body"
      end
      find(".block", text: hint.body ).click
      sleep 0.1
      answer.reload.body.should eq("test body")
    end

  end

end
