RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  
  config.main_app_name = [APP_CONFIG[:app_title], "Admin area"]
    
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  
  config.authorize_with do
    redirect_to(main_app.root_path, flash: {error: "You have to be admin to access admin area."}) unless warden.user.has_role? :root
  end
  
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
  
  config.current_user_method(&:current_user)

  config.actions do    
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    history_index
    history_show
  end
end
