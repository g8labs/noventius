FactoryGirl.define do
  factory :filter, class: Noventius::Filter do
    skip_create
    initialize_with { new(name, type, dirty_args) }

    transient do
      sequence(:name) { |n| "filter_#{n}" }
      type { Noventius::Filter::TYPES.sample }
      dirty_args { {} }
    end
  end
end
