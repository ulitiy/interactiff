Factory.define :domain do |f|
  f.sequence(:name){|n| "domain#{n}"}
end

Factory.define :host do |f|
  f.sequence(:name){ |n| "domain#{n}.lvh.me" }
  f.domain
end

Factory.define :game do |f|
  f.sequence(:name){ |n| "game#{n}" }
  f.description "some description"
  f.domain
end

Factory.define :task do |f|
  f.sequence(:name) { |n| "task#{n}" }
  f.comment "some comment"
  f.game
end

Factory.define :answer do |f|
  f.sequence(:body) { |n| "answer#{n}" }
  f.task
end

Factory.define :hint do |f|
  f.sequence(:body) { |n| "hint#{n}" }
  f.task
end
