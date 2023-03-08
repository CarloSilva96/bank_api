FactoryBot.define do
  factory 'new_client', class: 'Bank::Model::Client' do
    name { Faker::Name.name }
    last_name { Faker::Name.last_name }
    cpf { Faker::CPF.cpf }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 90) }
    email { Faker::Internet.email }
    password { Faker::Number.number.to_s }
  end
end