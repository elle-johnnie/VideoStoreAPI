# Pseudocode routes file

## pseudo-routes

  get /customers              to customers#index

  get /movies                 to movies#index
  get /movies/:id             to movies#show
  post /movies                to movies#create

  post '/rentals/check_out'   to rentals#check_out
  post '/rentals/check_in'    to rentals#check_in
  get /zomg                   to rentals#zomg


## real routes

  resources :customers, only: [:index]
  resources :movies, only: [:index, :show, :create]

  post '/rentals/check_out', to: 'rentals#check_out', as: 'check_out'
  post '/rentals/check_in', to: 'rentals#check_in', as: 'check_in'

  get '/zomg', to: 'rentals#zomg', as :'zomg'
