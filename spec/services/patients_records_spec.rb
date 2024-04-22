# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vandelay::Services::PatientRecords, type: :service do
  describe 'For vendor one' do
    let(:vendor_one) { double(Vandelay::Integrations::VendorOne) }

    let(:patient) do
      Vandelay::Models::Patient.new(
        full_name: 'Test user',
        records_vendor: 'one',
        date_of_birth: '1998-02-20',
        vendor_id: '743'
      )
    end

    let(:patient_response) do
      {
        "province": 'PLN',
        "allergies": [
          'stupidity'
        ],
        "random_accident": 100,
        "num_medical_visits": 100
      }
    end

    let(:patient_result) do
      {
        "id": '1',
        "province": 'PLN',
        "allergies": [
          'stupidity'
        ],
        "num_medical_visits": 100
      }
    end

    before do
      expect(Vandelay::Integrations::VendorOne).to receive(:new).and_return(vendor_one)
      expect(vendor_one).to receive(:fetch_vendor_data).and_return(patient_response)
    end

    it 'return patient_data' do
      service = described_class.new

      expect(service.retrieve_record_for_patient(patient)).to eq patient_result
    end
  end

  describe 'For vendor two' do
    let(:vendor_two) { double(Vandelay::Integrations::VendorTwo) }

    let(:patient) do
      Vandelay::Models::Patient.new(
        full_name: 'Test user',
        records_vendor: 'two',
        date_of_birth: '1998-02-20',
        vendor_id: '743'
      )
    end

    let(:patient_response) do
      {
        "province": 'PLN',
        "allergies": [
          'stupidity'
        ],
        "random_accident": 100,
        "num_medical_visits": 100
      }
    end

    let(:patient_result) do
      {
        "id": '1',
        "province": 'PLN',
        "allergies": [
          'stupidity'
        ],
        "num_medical_visits": 100
      }
    end
    before do
      expect(Vandelay::Integrations::VendorTwo).to receive(:new).and_return(vendor_two)
      expect(vendor_two).to receive(:fetch_vendor_data).and_return(patient_response)
    end

    it 'return patient_data' do
      service = described_class.new

      expect(service.retrieve_record_for_patient(patient)).to eq patient_result
    end
  end

  describe 'without vendor' do
    let(:patient) do
      Vandelay::Models::Patient.new(
        full_name: 'Test user',
        records_vendor: nil,
        date_of_birth: '1998-02-20',
        vendor_id: nil
      )
    end

    it 'return patient_data' do
      service = described_class.new

      expect(service.retrieve_record_for_patient(patient)).to eq({ id: '1' })
    end
  end
end
