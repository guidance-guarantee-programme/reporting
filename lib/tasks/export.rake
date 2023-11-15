# rubocop:disable Metrics/BlockLength
namespace :export do
  desc 'Export CSV data to blob storage for analysis'
  task blob: :environment do
    from_timestamp = ENV.fetch('FROM') { 3.months.ago }

    Satisfaction.public_send(:acts_as_copy_target)

    data = Satisfaction
           .where('created_at >= ? or updated_at >= ?', from_timestamp, from_timestamp)
           .select('
             id,
             given_at,
             uid,
             delivery_partner,
             satisfaction_raw,
             satisfaction,
             sms_response,
             location,
             created_at,
             updated_at
           ').order(:created_at).copy_to_string

    client = Azure::Storage::Blob::BlobService.create_from_connection_string(
      ENV.fetch('AZURE_CONNECTION_STRING')
    )

    client.create_block_blob(
      'pw-prd-data',
      "/To_Be_Processed/MAPS_PWBLZ_SATISFACTION_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv",
      data
    )
  end
end
# rubocop:enable Metrics/BlockLength
