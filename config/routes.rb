Rails.application.routes.draw do

  resources :images, controller: "kuppayam/images" do
    member do
      put :crop
    end
  end

  resources :documents, controller: "kuppayam/documents" do
    member do
      put :download
    end
  end

  resources :import_data, controller: "kuppayam/import_data"

end
