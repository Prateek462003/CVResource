class AddSimulatorVersionToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :simulatorVersion, :string, default: '1.0', null: false
  end
end


