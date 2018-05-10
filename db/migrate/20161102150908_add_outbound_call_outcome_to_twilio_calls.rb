class AddOutboundCallOutcomeToTwilioCalls < ActiveRecord::Migration[4.2]
  def change
    add_column :twilio_calls, :outbound_call_outcome, :string, default: '', null: false
  end
end
