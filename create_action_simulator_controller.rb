  def create
    @project = Project.new
    @project.build_project_datum.data = sanitize_data(@project, params[:data])
    @project.name = sanitize(params[:name])
    @project.author = current_user
    # Latest will be replaced by the latest version for the simulator
    simulator_version = "latest"
    # ActiveStorage
    io_image_file = parse_image_data_url(params[:image])
    attach_circuit_preview(io_image_file)
    # CarrierWave
    image_file = return_image_file(params[:image])
    @project.image_preview = image_file
    image_file.close
    # Update project data with simulator version
    @project.build_project_datum.data.merge!({ "simulatorVersion": simulator_version })
    @project.save!

    # render plain: simulator_path(@project)
    # render plain: user_project_url(current_user,@project)
    redirect_to edit_user_project_url(current_user, @project)
  end
