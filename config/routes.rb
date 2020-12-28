Rails.application.routes.draw do
  post 'reports/handle', to: 'reports#handle', as: :handle_report, defaults: { format: :json }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
