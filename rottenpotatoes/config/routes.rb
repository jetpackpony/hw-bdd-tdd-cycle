Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  # get ':controller/:id/:action'
  get ':controller/:id/:action'
end
