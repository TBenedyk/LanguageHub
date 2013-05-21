class CreateLookups < ActiveRecord::Migration
  def change
    create_table :lookups do |t|

      t.timestamps
    end
  end
end
