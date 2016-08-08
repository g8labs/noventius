FactoryGirl.define do
  factory :validation, class: Noventius::Validation do
    skip_create
    initialize_with { new(name, rules, messages) }

    transient do
      sequence(:name) { |n| "validation_#{n}" }
      rules { {} }
      messages { {} }
    end
  end
end
