class UpdateIssueCircuitDataWithVersion < ActiveRecord::Migration[7.0]
  def up
    IssueCircuitDatum.all.each do |datum|
      # Parse the existing JSON data
      data = JSON.parse(datum.data) rescue {}

      # Check if simulatorVersion key doesn't already exists this is to be done for only old circuits 
      unless data.key?("simulatorVersion")
        simulator_version = retrieve_simulator_version(datum)
        # Update data with simulatorVersion key-value pair
        data["simulatorVersion"] = "version1"
      end

      datum.update!(data: data.to_json)
    end
  end

  def down
    # Implement logic to revert the changes if necessary (optional)
    raise ActiveRecord::IrreversibleMigration, "Cannot revert this migration"
  end

end
