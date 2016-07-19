Rails.application.routes.draw do

  

  # custom routes
  get 'dodaj-slowko' => 'words#new', as: 'new_word'
  get 'lista-slowek' => 'words#index', as: 'words'
  get 'words/game' => 'words/game', as: 'game'
  get 'words/check_word' => 'words/check_word', as: 'check_word'
  get 'szukaj' => 'words#search', as: 'search_words'
  get 'moje-slowka' => 'words#my_words', as: 'my_words'
  get 'words/game_ajax' => 'words/game_ajax', as: 'game_ajax'
  get 'do-weryfikacji' => 'words#to_verify', as: 'words_to_verify'

  devise_for :users, :controllers => { registrations: 'registrations' }

  # set root
  root 'words#game'

  mount Commontator::Engine => '/commontator'

  # resources
  resources :words do
    collection do
      get 'search'
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
