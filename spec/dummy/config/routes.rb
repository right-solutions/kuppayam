Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "demo/home#index"

  resources :events, controller: "demo/events" do
    member do
      put :update_status, as:  :update_status
    end
  end

end
