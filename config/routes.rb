MyThreeFavorite::Application.routes.draw do
  match 'timeline' => 'timeline#create', via: :post
  match 'timeline/update' => 'timeline#update', via: :get
  root to: 'timeline#index'
end
