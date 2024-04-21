# frozen_string_literal: true

require 'vandelay/integrations/base'

module Vandelay
  module Integrations
    class VendorOne < Base
      BASE_URL = 'http://mock_api_one:80'

      def build_record_response(data)
        return {} if data.empty?

        {
          province: data['province'],
          allergies: data['allergies'],
          num_medical_visits: data['recent_medical_visits']
        }
      end

      def token(data)
        data['token']
      end

      def token_url
        "#{BASE_URL}/auth/1"
      end

      def patient_url
        return nil unless vendor_id

        "#{BASE_URL}/patients/#{vendor_id}"
      end
    end
  end
end
