class CreateKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :keywords do |t|
      t.string :username
      t.string :word

      t.timestamps
    end
  end
end
