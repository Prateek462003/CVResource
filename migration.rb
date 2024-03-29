class UpdateProjectDataWithVersion < ActiveRecord::Migration[7.0]
  def up
    ProjectDatum.all.each do |datum|
      # Parse the existing JSON data
      data = JSON.parse(datum.data) rescue {}

      # Check if simulatorVersion key doesn't already exists this is to be done for only old circuits 
      unless data.key?("simulatorVersion")
        # Assuming old circuits have to be loaded on version1
        data["simulatorVersion"] = "version1"
      end

      datum.update!(data: data.to_json)
    end
  end
end

