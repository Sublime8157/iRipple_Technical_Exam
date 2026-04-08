module Api
  module V1
    class ProductsController < ApplicationController

      # fetch all the products GET /api/V1/Products
      def index
        products = Product.all
        products = products.where(status: 'A') if params[:status] == 'active'
        products = products
                  .order(id: :desc)
                  .page(params[:page])
                  .per(params[:per_page] || 10)
        
        render json: {
          data: products, 
          meta: {
            current_page:  products.current_page,
            total_pages:   products.total_pages,
            total_count:   products.total_count,
            per_page:      products.limit_value
          },
        }, status: :ok
      end

      # create new product POST /api/v1/Products
      def create
        status = params[:status]
        items  = params[:data]

        unless status == "C"
          return render json: { error: "Status must be 'C' to create products" }, status: :unprocessable_entity
        end

        created = []
        errors  = []

        ActiveRecord::Base.transaction do
          items.each do |item|
            product = Product.new(
              name:   item[:name],
              code:   item[:code],
              price:  item[:price],
              status: "C"
            )

            unless product.save
              errors << { code: item[:code], errors: product.errors.full_messages }
            else
              created << product
            end
          end

          # If any errors, rollback
          raise ActiveRecord::Rollback if errors.any?
        end

        if errors.any?
          render json: { message: "Some products failed", created: created, errors: errors }, status: :unprocessable_entity
        else
          render json: { message: "All products created successfully", created: created }, status: :created
        end
      end

      # PUT /api/v1/products/:id
      def update
        product = Product.find_by(id: params[:id])

        unless product
          return render json: { error: "Product not found" }, status: :not_found
        end

        if product.update(
          name:   params[:name]   || product.name,
          code:   params[:code]   || product.code,
          price:  params[:price]  || product.price,
          status: params[:status] || product.status
        )
          render json: { message: "Product updated successfully", data: product }, status: :ok
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end
    
      # DELETE /api/v1/products/:id
      def destroy
        product = Product.find_by(id: params[:id])
        
        unless product
          return render json: { error: "Product not found" }, status: :not_found
        end

        begin
          if product.destroy
            render json: { message: "Product deleted successfully" }, status: :ok
          else
            render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
          end
        rescue ActiveRecord::InvalidForeignKey
          render json: { error: "Cannot delete because some order is using this product" }, status: :unprocessable_entity
        rescue StandardError => e
          render json: { error: "Failed to delete product" }, status: :internal_server_error
        end
      end
    end
  end
end
