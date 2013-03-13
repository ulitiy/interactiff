# encoding: UTF-8
require 'spec_helper'

describe "Play UI" do
  include Warden::Test::Helpers
  Warden.test_mode!
  let!(:domain) { create :domain }
  let!(:game) do
    Game.skip_callback(:validation, :before, :new_game)
    create :game
  end
  let!(:gs) { create :game_started, parent: game, time: 1.day.ago }
  let!(:gp) { create :game_passed, parent: game }
  let!(:task1) { create :task, name: "task 1", parent: game, input_type: "link" }
  let!(:tg1) { create :task_given, parent: task1 }
  let!(:tp1) { create :task_passed, parent: task1 }
  let!(:ac1) { create :answer, parent: task1 }
  let!(:al1) { create :answer, parent: task1, reusable: :for_all }
  let!(:user) { create :root_user }

  before do
    login_as(user, scope: :user)
  end

  context "using rooms" do
    let!(:task2) { create :task, name: "task 2", parent: game, input_type: "link" }
    let!(:tg2) { create :task_given, parent: task2 }
    let!(:tp2) { create :task_passed, parent: task2 }
    let!(:al2) { create :answer, parent: task2, reusable: :for_all }

    before do
      Relation.from_array [
        [gs, tg1],
        [ac1, tp1, gp],
        [al1, tp1, tg2],
        [al2, tg1]
      ]
    end

    it do
      visit play_show_path game_id: game.id, task_id: task1.id
      click_link al1.body #прошли 1
      click_link al2.body #прошли 2
      # visit play_game_path game_id: game.id # редирект неправильный. Исправить.
      click_link al1.body#####
      click_link al2.body
      # visit play_game_path game_id: game.id # редирект неправильный. Исправить.
      click_link ac1.body
      page.should have_selector(".win")
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