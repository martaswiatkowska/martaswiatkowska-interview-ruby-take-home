# frozen_string_literal: true

require 'vandelay/integrations/vendor_one'
require 'vandelay/integrations/vendor_two'

module Vandelay
  module Services
    class PatientRecords
      RECORDS_TO_RETURN = %i[id province allergies num_medical_visits].freeze

      def retrieve_record_for_patient(patient)
        vendor_data = vendor_data(patient)
        patient_data(patient, vendor_data)
      end

      private

      def vendor_data(patient)
        vendor_id = patient.records_vendor
        return nil unless vendor_id

        vendor = vendor_class(vendor_id).new(patient)
        vendor.fetch_vendor_data
      end

      def patient_data(patient, vendor_data)
        (vendor_data || {}).merge("id": patient.id).slice(*RECORDS_TO_RETURN)
      end

      def vendor_class(vendor_id)
        case vendor_id
        when 'one'
          Object.const_get('Vandelay::Integrations::VendorOne')
        when 'two'
          Object.const_get('Vandelay::Integrations::VendorTwo')
        end
      end
    end
  end
end
