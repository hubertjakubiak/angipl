Rails.application.routes.draw do

  get 'czasy', to: 'games#index'
  get 'czat', to: 'games#index'

  get 'contact', to: 'pages#contact'

  post 'games/check'

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
end
