FactoryBot.define do
  factory :user do
    name { 'user1' }
    email { 'user@u.com' }
    password { 'userpass1' }
    password_confirmation { 'userpass1' }
  end
  factory :user2, class: User do
    name { 'user2' }
    email { 'user2@u.com' }
    password { 'userpass2' }
    password_confirmation { 'userpass2' }
  end
  factory :admin_user, class: User do
    name { 'admin_user' }
    email { 'admin@a.com' }
    password { 'adminpass' }
    password_confirmation { 'adminpass' }
    admin { true }
  end
end
