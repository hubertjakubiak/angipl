Rails.application.routes.draw do

  get 'czasy', to: 'games#index'
  get 'czat', to: 'games#index'

  get 'contact', to: 'pages#contact'

  get 'games/check'

  get 'settings/index'

  get '/rankings/users', to: 'rankings#users'
  resources :settings

  mount RailsAdmin::Engine => '/hubert', as: 'rails_admin'
  devise_for :admins, :controllers => { registrations: 'admins_registrations'}
  devise_for :users, :controllers => { registrations: 'registrations'}

  # custom routes
  #get 'search' => 'words#search', as: 'search_words'
  #get 'lista-slowek' => 'words#index', as: 'words'
  #get 'moje-slowka' => 'words#my', as: 'my_words'
  #get 'do-weryfikacji' => 'words#to_verify', as: 'to_verify_words'
  #get 'dodaj-slowko' => 'words#new', as: 'new_word'
  #post 'lista-slowek' => 'words#create'
  #get 'szukaj' => 'words#search', as: 'search_words'
  #get 'sprawdz' => 'words#check', as: 'check_words'

  #devise_for  :users, :path => '', 
  #            :path_names => {:sign_up => 'rejestracja', 
  #                            :sign_in => 'logowanie', 
  #                            :sign_out => 'wyloguj-sie',
  #                            :edit => 'edytuj-profil'}, 
  #            :controllers => { registrations: 'registrations' }

  # set root
  root 'games#index'

  # resources

  resources :words do

    resources :comments, except: [:index], controller: "words/comments"

    collection do
      get 'search'
      get 'my'
      get 'to-verify'
      post 'import'
    end

    member do
      get 'upvote'
      get 'downvote'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
