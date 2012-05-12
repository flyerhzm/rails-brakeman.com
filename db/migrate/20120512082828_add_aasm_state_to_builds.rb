class AddAasmStateToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :aasm_state, :string
  end
end
