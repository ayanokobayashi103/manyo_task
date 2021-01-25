FactoryBot.define do
  factory :user do
    name { 'user1' }
    email { 'user@u.com' }
    password { 'userpass1' }
    password_confirmation { 'userpass1' }
  end
  factory :admin_user do
    name { 'admin_user' }
    email { 'admin@a.com' }
    password { 'adminpass' }
    password_confirmation { 'adminpass' }
    admin { true }
  end
  
end
