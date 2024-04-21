# frozen_string_literal: true

require 'net/http'

module Vandelay
  module Integrations
    class Base
      def initialize(patient)
        @patient = patient
      end

      def fetch_vendor_data
        return nil unless patient_url

        uri = URI.parse(patient_url)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        request['Authorization'] = "Bearer: #{auth_token}"
        response = http.request(request)
        build_record_response(parse_data(response.body))
      end

      def build_record_response(data)
        raise NotImplementedError, 'Implement build_record_response method in a child class'
      end

      def token(data)
        raise NotImplementedError, 'Implement token method in a child class'
      end

      def token_url
        raise NotImplementedError, 'Implement token_url method in a child class'
      end

      def patient_url
        raise NotImplementedError, 'Implement patient_url method in a child class'
      end

      private

      def auth_token
        uri_token = URI.parse(token_url)
        response = Net::HTTP.get_response(uri_token)
        token(parse_data(response.body))
      end

      def parse_data(data)
        JSON.parse(data)
      end

      def vendor_id
        @patient.vendor_id
      end
    end
  end
end
