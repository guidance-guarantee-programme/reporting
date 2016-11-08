class AddOutboundCallOutcomeToTwilioCalls < ActiveRecord::Migration
  def change
    add_column :twilio_calls, :outbound_call_outcome, :string, default: '', null: false
  end
end
