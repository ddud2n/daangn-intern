class CreateAlarms < ActiveRecord::Migration[6.0]
  def change
    create_table :alarms do |t|
      t.string :username
      t.string :word
      t.text :title
      t.text :description

      t.timestamps
    end
  end
end
