require 'rails_helper'

RSpec.describe Api::CommunicationsController, type: :controller do
  let(:practitioner) { Practitioner.create(first_name: 'Fritz', last_name: 'Kertzmann') }
  let(:date) { '2019-01-01' }
  let(:communication) { Communication.create(practitioner_id: practitioner.id, sent_at: date) }

  describe 'GET #index' do
    before do
      communication
      get :index
    end

    it 'successfully respond with JSON body containing expected list of Communications' do
      expect(response).to have_http_status(:ok)
      array_body = []
      expect { array_body = JSON.parse(response.body, symbolize_names: true) }.not_to raise_exception
      expect(array_body.size).to eq(1)
      expect(array_body[0][:first_name]).to eq('Fritz')
      expect(array_body[0][:last_name]).to eq('Kertzmann')
      expect(array_body[0][:sent_at].to_date.to_s).to eq('2019-01-01')
    end
  end

  describe 'POST #create' do
    before do
      practitioner
      post :create, params: { communication: {
        first_name: 'Fritz',
        last_name: 'Kertzmann',
        sent_at: '2019-01-01'
      } }
    end

    it 'successfully respond with JSON body containing expected just-created Communication' do
      expect(response).to have_http_status(:created)
      object_body = {}
      expect { object_body = JSON.parse(response.body, symbolize_names: true) }.not_to raise_exception
      expect(object_body[:first_name]).to eq('Fritz')
      expect(object_body[:last_name]).to eq('Kertzmann')
      expect(object_body[:sent_at].to_date.to_s).to eq('2019-01-01')
    end
  end
end
