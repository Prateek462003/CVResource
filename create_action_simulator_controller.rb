  def create
    @project = Project.new
    @project.build_project_datum.data = sanitize_data(@project, params[:data])
    @project.name = sanitize(params[:name])
    @project.author = current_user

    # Newly Created circuits will be made on vue simulaltor that will be store in config/application.rb
    @project.simulaltorVersion = Rails.configuration.simulaltor_version
    
    # ActiveStorage
    io_image_file = parse_image_data_url(params[:image])
    attach_circuit_preview(io_image_file)
    # CarrierWave
    image_file = return_image_file(params[:image])
    @project.image_preview = image_file
    image_file.close
    @project.save!

    # render plain: simulator_path(@project)
    # render plain: user_project_url(current_user,@project)
    redirect_to edit_user_project_url(current_user, @project)
  end
