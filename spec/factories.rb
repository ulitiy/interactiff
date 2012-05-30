FactoryGirl.define do
  factory :domain do
    sequence(:name){|n| "domain#{n}"}
  end

  factory :host do
    sequence(:name){ |n| "domain#{n}.lvh.me" }
  end

  factory :game do
    sequence(:name){ |n| "game#{n}" }
    description "some description"
  end

  factory :task do
    sequence(:name) { |n| "task#{n}" }
  end

  factory :answer do
    sequence(:body) { |n| "answer#{n}" }
  end

  factory :hint do
    sequence(:body) { |n| "hint#{n}" }
  end

  factory :relation do
    association :from, factory: :answer
    association :to, factory: :hint

    factory :game_relation do
      association :game
    end
  end
end
