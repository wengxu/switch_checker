Rails.application.routes.draw do
  get 'check/switch'

  get 'check/get_status' => 'check#get_status'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'check#switch'
end
