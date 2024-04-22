# frozen_string_literal: true

require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/:patient_id' do
          result = Vandelay::REST::Patients.patients_srvc.retrieve_one(params['patient_id'].to_i)

          if result.nil?
            json({ success: false, status: 404, error: 'No patient for this id' })
          else
            json({ success: true, status: 200, record: result })
          end
        end

        app.get '/patients/:patient_id/record' do
          patient = Vandelay::REST::PatientsPatient.patients_srvc.retrieve_one(params['patient_id'])
          result  = Vandelay::Services::PatientRecords.new.retrieve_record_for_patient(patient)

          if result.nil?
            return json({ status: 404, message: 'Patient not found', system_time: Vandelay.system_time_now.iso8601 })
          end

          json({ status: 200, success: true, record: result })
        end
      end
    end
  end
end
