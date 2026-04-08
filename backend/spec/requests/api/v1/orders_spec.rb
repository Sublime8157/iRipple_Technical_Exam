require 'rails_helper'

RSpec.describe 'Api::V1::Orders', type: :request do
  describe 'GET /api/v1/orders' do
    it 'returns all orders with items' do
      order   = create(:order, total_amount: 200)
      product = create(:product, price: 100)
      create(:order_item, order: order, product: product, quantity: 2, price: 100)

      get '/api/v1/orders'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].first['items'].length).to eq(1)
    end
  end

  describe 'POST /api/v1/orders' do
    it 'creates an order and computes total' do
      product = create(:product, price: 100, status: 'A')

      post '/api/v1/orders', params: {
        items: [{ product_id: product.id, quantity: 2 }]
      }, as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['total_amount']).to eq(200.0)
    end

    it 'rejects order with invalid product' do
      post '/api/v1/orders', params: {
        items: [{ product_id: 9999, quantity: 1 }]
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'rejects order with empty items' do
      post '/api/v1/orders', params: { items: [] }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /api/v1/orders/:id' do
    it 'updates order status' do
      order = create(:order, status: 'P')
      put "/api/v1/orders/#{order.id}", params: { status: 'C' }, as: :json
      expect(response).to have_http_status(:ok)
      expect(order.reload.status).to eq('C')
    end

    it 'returns not found for invalid id' do
      put '/api/v1/orders/9999', params: { status: 'C' }, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/orders/:id' do
    it 'deletes an order' do
      order = create(:order)
      delete "/api/v1/orders/#{order.id}"
      expect(response).to have_http_status(:ok)
      expect(Order.find_by(id: order.id)).to be_nil
    end

    it 'returns not found for invalid id' do
      delete '/api/v1/orders/9999'
      expect(response).to have_http_status(:not_found)
    end
  end
end