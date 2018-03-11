Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'demo/xenon' 				=> "demo/xenon_home#index", as: :xenon_index
  get 'demo/materialize' 	=> "demo/materialize_home#index", as: :materialize_index

  root to: "demo/xenon_home#index"

  resources :events, controller: "demo/events" do
    member do
      put :update_status, as:  :update_status
    end
  end

end
