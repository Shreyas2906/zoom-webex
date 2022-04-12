Rails.application.routes.draw do
  resources :homes
  resources :webs
  resources :meetings
  root 'homes#index'


  

  get "/all_meetings", to: "meetings#all_meetings"
  get "/all_schedule_meetings/:type", to: "meetings#all_schedule_meetings"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
