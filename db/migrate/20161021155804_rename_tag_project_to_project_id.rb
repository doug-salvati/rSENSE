class RenameTagProjectToProjectId < ActiveRecord::Migration
  def change
    rename_column :tags, :project, :project_id
  end
end
