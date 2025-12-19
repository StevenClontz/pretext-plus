class AddHtmlSourceToProject < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :html_source, :text
  end
end
