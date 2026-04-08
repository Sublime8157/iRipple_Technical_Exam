require 'rails_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  describe 'GET /api/v1/products' do
    it 'returns all products' do
      create_list(:product, 3)
      get '/api/v1/products'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].length).to eq(3)
    end
  end

  describe 'POST /api/v1/products' do
    it 'creates products with status C' do
      post '/api/v1/products', params: {
        status: 'C',
        data: [
          { name: 'Coffee', code: 'COFFEE', price: 100 },
          { name: 'Sandwich', code: 'SNDWCH', price: 150 }
        ]
      }, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['created'].length).to eq(2)
    end

    it 'rejects creation with wrong status' do
      post '/api/v1/products', params: {
        status: 'X',
        data: [{ name: 'Coffee', code: 'COFFEE', price: 100 }]
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /api/v1/products/:id' do
    it 'updates product to active' do
      product = create(:product, status: 'C')
      put "/api/v1/products/#{product.id}", params: { status: 'A' }, as: :json
      expect(response).to have_http_status(:ok)
      expect(product.reload.status).to eq('A')
    end

    it 'returns not found for invalid id' do
      put '/api/v1/products/9999', params: { status: 'A' }, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    it 'deletes a product' do
      product = create(:product)
      delete "/api/v1/products/#{product.id}"
      expect(response).to have_http_status(:ok)
      expect(Product.find_by(id: product.id)).to be_nil
    end

    it 'returns not found for invalid id' do
      delete '/api/v1/products/9999'
      expect(response).to have_http_status(:not_found)
    end
  end
end