require 'spec_helper'

describe "Play UI" do
  include Warden::Test::Helpers
  Warden.test_mode!
  let!(:domain) { create :domain }
  let!(:game) do
    Game.skip_callback(:validation, :before, :new_game)
    Game.skip_callback(:create, :after, :start)
    create :game
  end
  let!(:task1) { create :task, name: "task 1", parent: game, input_type: "link", order: 0 }
  let!(:tg1) { create :task_given, parent: task1 }
  let!(:tp1) { create :task_passed, parent: task1 }
  let!(:ac1) { create :answer, parent: task1 }
  let!(:al1) { create :answer, parent: task1 }
  let!(:user) { create :root_user, confirmed_at: Time.now }

  before do
    login_as(user, scope: :user)
    game.start
  end

  context "using rooms" do
    let!(:task2) { create :task, name: "task 2", parent: game, input_type: "link" }
    let!(:tg2) { create :task_given, parent: task2 }
    let!(:task3) { create :task, name: "task 3", parent: game, input_type: "link" }
    let!(:tg3) { create :task_given, parent: task3 }
    let!(:tp2) { create :task_passed, parent: task2 }
    let!(:al2) { create :answer, parent: task2 }

    before do
      Relation.from_array [
        [ac1, tp1, tg3], #на выход
        [al1, tp1, tg2], #на второе
        [al2, tp2, tg1] #назад
      ]
    end

    it do
      visit play_show_path game_id: game.id, task_id: task1.id, locale: :ru
      click_link al1.body #прошли 1
      click_link al2.body #прошли 2
      click_link al1.body #1
      click_link al2.body #2
      click_link ac1.body #1->3
      find(".span7 h2").should have_content("task 3")
    end
  end

  context "redirects"
  #редиректы по play
  #до, срабатывание таймера, после, нет заданий

  context "answers"
  #тыкнул неверный - не прошел
  #тыкнул верный - прошел
  #ввел неверный - не прошел
  #ввел верный - прошел

end