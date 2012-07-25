class AddPeriodToEvents < ActiveRecord::Migration
  def change
    add_column :events, :period, :integer
  end
end
