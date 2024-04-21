# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Vandelay::Integrations::VendorTwo', type: :service do
  let(:vendor) { Vandelay::Integrations::VendorTwo.new(patient) }
  let(:auth_token) { { 'id' => '1', 'auth_token' => '349rijed934r8ij123$==' } }

  let(:patient) do
    Vandelay::Models::Patient.new(
      full_name: 'Test user',
      records_vendor: 'two',
      date_of_birth: '1998-02-20',
      vendor_id: '16'
    )
  end

  let(:patient_response) do
    {
      'province_code' => 'ON',
      'allergies_list' => [
        'mean people'
      ],
      'random_accident' => 100,
      'medical_visits_recently' => 100
    }
  end

  context 'when existed entity' do
    it 'should return proper response' do
      response = vendor.build_record_response(patient_response)
      expect(response).to eq({ "province": 'ON', "allergies": ['mean people'], "num_medical_visits": 100 })
    end

    it 'should fetch the authentication token' do
      expect(vendor.token(auth_token)).to eq('349rijed934r8ij123$==')
    end

    it 'should return proper token_url' do
      expect(vendor.token_url).to eq('http://mock_api_two:80/auth_tokens/1')
    end

    it 'should return proper patient_api_url' do
      expect(vendor.patient_url).to eq('http://mock_api_two:80/records/16')
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
      expect(vendor.token_url).to eq('http://mock_api_two:80/auth_tokens/1')
    end

    it 'should return proper patient_api_url' do
      expect(vendor.patient_url).to eq('http://mock_api_two:80/records/14')
    end
  end
end
