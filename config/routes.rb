Rails.application.routes.draw do
  get 'customers/index'
  get 'movies/show'
  get 'movies/index'
  get 'movies/create'
  get 'movies/update'
  get 'rentals/index'
  get 'rentals/show'
  get 'rentals/update'
  get 'customer/index'
  get 'customer/show'
  get 'customer/create'
  get 'customer/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
