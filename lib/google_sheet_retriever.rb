require 'google/apis/sheets_v4'
require 'google/api_client/auth/key_utils'

class GoogleSheetRetriever
  def initialize(config:)
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.authorization = authorization(config)
    @service.authorization.fetch_access_token!
  end

  def get(sheet_id, range)
    @service.get_spreadsheet_values(sheet_id, range)
  end

  private

  def authorization(config)
    key = Google::APIClient::KeyUtils.load_from_pkcs12(config.key_data, config.key_secret)

    Signet::OAuth2::Client.new(
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      audience: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY,
      issuer: config.service_account_email,
      signing_key: key
    )
  end
end
