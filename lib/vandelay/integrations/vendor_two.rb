# frozen_string_literal: true

require 'vandelay/integrations/base'

module Vandelay
  module Integrations
    class VendorTwo < Base
      BASE_URL = 'http://mock_api_two:80'

      def build_record_response(data)
        return {} if data.empty?

        {
          province: data['province_code'],
          allergies: data['allergies_list'],
          num_medical_visits: data['medical_visits_recently']
        }
      end

      def token(data)
        data['auth_token']
      end

      def token_url
        "#{BASE_URL}/auth_tokens/1"
      end

      def patient_url
        return nil unless vendor_id

        "#{BASE_URL}/records/#{vendor_id}"
      end
    end
  end
end
