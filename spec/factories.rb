FactoryGirl.define do
  factory :domain do |f|
    f.sequence(:name){|n| "domain#{n}"}
  end

  factory :host do |f|
    f.sequence(:name){ |n| "domain#{n}.lvh.me" }
    f.domain
  end

  factory :game do |f|
    f.sequence(:name){ |n| "game#{n}" }
    f.description "some description"
    f.domain
  end

  factory :task do |f|
    f.sequence(:name) { |n| "task#{n}" }
    f.comment "some comment"
    f.game
  end

  factory :answer do |f|
    f.sequence(:body) { |n| "answer#{n}" }
    f.task
  end

  factory :hint do |f|
    f.sequence(:body) { |n| "hint#{n}" }
    f.task
  end
end
