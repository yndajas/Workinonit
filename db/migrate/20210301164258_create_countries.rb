class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name

      t.timestamps
    end

    Country.create(name: "Argentina")
    Country.create(name: "Australia")
    Country.create(name: "Austria")
    Country.create(name: "Bahrain")
    Country.create(name: "Belgium")
    Country.create(name: "Brazil")
    Country.create(name: "Canada")
    Country.create(name: "Chile")
    Country.create(name: "China")
    Country.create(name: "Colombia")
    Country.create(name: "Costa Rica")
    Country.create(name: "Czech Republic")
    Country.create(name: "Denmark")
    Country.create(name: "Ecuador")
    Country.create(name: "Egypt")
    Country.create(name: "Finland")
    Country.create(name: "France")
    Country.create(name: "Germany")
    Country.create(name: "Greece")
    Country.create(name: "Hong Kong")
    Country.create(name: "Hungary")
    Country.create(name: "India")
    Country.create(name: "Indonesia")
    Country.create(name: "Ireland")
    Country.create(name: "Israel")
    Country.create(name: "Italy")
    Country.create(name: "Japan")
    Country.create(name: "Kuwait")
    Country.create(name: "Luxembourg")
    Country.create(name: "Malaysia")
    Country.create(name: "Mexico")
    Country.create(name: "Morocco")
    Country.create(name: "Netherlands")
    Country.create(name: "New Zealand")
    Country.create(name: "Nigeria")
    Country.create(name: "Norway")
    Country.create(name: "Oman")
    Country.create(name: "Pakistan")
    Country.create(name: "Panama")
    Country.create(name: "Peru")
    Country.create(name: "Philippines")
    Country.create(name: "Poland")
    Country.create(name: "Portugal")
    Country.create(name: "Qatar")
    Country.create(name: "Romania")
    Country.create(name: "Russia")
    Country.create(name: "Saudi Arabia")
    Country.create(name: "Singapore")
    Country.create(name: "South Africa")
    Country.create(name: "South Korea")
    Country.create(name: "Spain")
    Country.create(name: "Sweden")
    Country.create(name: "Switzerland")
    Country.create(name: "Taiwan")
    Country.create(name: "Thailand")
    Country.create(name: "Turkey")
    Country.create(name: "Ukraine")
    Country.create(name: "United Arab Emirates")
    Country.create(name: "United Kingdom")
    Country.create(name: "United States")
    Country.create(name: "Uruguay")
    Country.create(name: "Venezuela")
    Country.create(name: "Vietnam")
  end
end
