class CreateProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :properties do |t|
      t.string :offer_type
      t.string :property_type
      t.string :zip_code
      t.string :city
      t.string :street
      t.string :house_number
      t.decimal :lng
      t.decimal :lat
      t.integer :construction_year
      t.decimal :number_of_rooms
      t.string :currency
      t.decimal :price

      t.timestamps
    end
  end
end
