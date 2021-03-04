class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.string :name
      t.integer :order

      t.timestamps

    end

    Status.create(name: "Not started", order: 1)
    Status.create(name: "Preparing application", order: 2)
    Status.create(name: "Applied", order: 3)
    Status.create(name: "Invited to interview", order: 4)
    Status.create(name: "Awaiting outcome", order: 5)
    Status.create(name: "Unsuccessful", order: 6)
    Status.create(name: "Offer received", order: 7)
    Status.create(name: "Offer accepted", order: 8)
  end
end
