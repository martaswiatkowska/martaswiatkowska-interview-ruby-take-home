# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Vandelay::Integrations::VendorOne', type: :service do
  let(:vendor) { Vandelay::Integrations::VendorOne.new(patient) }
  let(:auth_token) { { 'id' => '1', 'token' => '129e8ry23uhj23948rhu23' } }

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
      'province' => 'PLN',
      'allergies' => [
        'stupidity'
      ],
      'random_accident' => 100,
      'recent_medical_visits' => 100
    }
  end

  context 'when existed entity' do
    it 'should return proper response' do
      response = vendor.build_record_response(patient_response)
      expect(response).to eq({ "province": 'PLN', "allergies": ['stupidity'], "num_medical_visits": 100 })
    end

    it 'should fetch the authentication token' do
      expect(vendor.token(auth_token)).to eq('129e8ry23uhj23948rhu23')
    end

    it 'should return token_url' do
      expect(vendor.token_url).to eq('http://mock_api_one:80/auth/1')
    end

    it 'should return patient_api_url' do
      expect(vendor.patient_url).to eq('http://mock_api_one:80/patients/743')
    end
  end

  context 'when there is no entity' do
    let(:patient) do
      Vandelay::Models::Patient.new(
        full_name: 'Test user',
        records_vendor: 'two',
        date_of_birth: '1998-02-20',
        vendor_id: '14'
      )
    end

    let(:patient_response) { {} }

    it 'should return error' do
      response = vendor.build_record_response(patient_response)
      expect(response).to be_empty
    end

    it 'should fetch the authentication token', skip: 'In the future should be test for checking if user can auth' do
      expect(vendor.token(auth_token)).to be_nil
    end

    it 'should return proper token_url' do
      expect(vendor.token_url).to eq('http://mock_api_one:80/auth/1')
    end

    it 'should return proper patient_api_url' do
      expect(vendor.patient_url).to eq('http://mock_api_one:80/patients/14')
    end
  end
end
