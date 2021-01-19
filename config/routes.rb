Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
#  resources :searches,only:[:index]
end
