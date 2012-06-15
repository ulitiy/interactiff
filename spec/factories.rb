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

  factory :user do
    sequence(:email,1000) { |n| "#{n}user@example.com" }
    password "secret"
    factory :user_with_role, aliases: [:root_user] do
      ignore do
        block nil
        access :manage_roles
      end
      after(:create) { |user, evaluator| user.roles.create block: evaluator.block, access: evaluator.access }
    end
  end

  factory :and_block
end
