# frozen_string_literal: true

require 'rack/test'

RSpec.describe 'Vandelay::REST::PatientsPatient', type: :request do
  let(:app) { RESTServer.new }

  describe 'GET /patients/:id/record' do
    it 'return data for user 1' do
      mock_request = Rack::MockRequest.new(app)
      json_response = mock_request.get('/patients/1/record')
      response = JSON.parse(json_response.body)['record']
      expect(json_response.status).to eq 200

      expect(response['id']).to eq '1'
    end

    it 'return data for user data from vendor one' do
      mock_request = Rack::MockRequest.new(app)
      json_response = mock_request.get('/patients/2/record')
      response = JSON.parse(json_response.body)['record']
      expect(json_response.status).to eq 200
      expect(response['id']).to eq '2'
      expect(response['province']).to eq 'Dunno QC'
      expect(response['allergies']).to eq ['work']
      expect(response['num_medical_visits']).to eq 100
    end

    it 'return data for user data from vendor two' do
      mock_request = Rack::MockRequest.new(app)
      json_response = mock_request.get('/patients/3/record')
      response = JSON.parse(json_response.body)['record']
      expect(json_response.status).to eq 200
      expect(response['id']).to eq '3'
      expect(response['province']).to eq 'Dunno ON'
      expect(response['allergies']).to eq ['more work']
      expect(response['num_medical_visits']).to eq 101
    end
  end

  describe 'GET /patients/:id' do
    it 'return data for user 1' do
      mock_request = Rack::MockRequest.new(app)
      json_response = mock_request.get('/patients/1')
      response = JSON.parse(json_response.body)['record']
      expect(json_response.status).to eq 200
      expect(response['id']).to eq '1'
      expect(response['full_name']).to eq 'Elaine Benes'
      expect(response['record_vendor']).to be_nil
    end
  end
end
