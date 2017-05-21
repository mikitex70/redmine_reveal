# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
RedmineApp::Application.routes.draw do
  match '/projects/:project_id/wiki/:id/presentation', :to => 'wiki#presentation', :via => :get
end
