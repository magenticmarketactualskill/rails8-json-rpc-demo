class DataController < ApplicationController
  def new
    @users = User.all
  end

  def create_user
    @user = User.create!(
      name: params[:name],
      email: params[:email]
    )

    # Create outgoing record for the user
    OutgoingRecord.create!(
      record_type: 'user',
      source_id: @user.id,
      data: @user.as_json,
      status: 'pending'
    )

    redirect_to root_path, notice: "User '#{@user.name}' created and queued for sending."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to root_path, alert: "Failed to create user: #{e.message}"
  end

  def create_order
    @user = User.find(params[:user_id])
    @order = Order.create!(
      user: @user,
      product_name: params[:product_name],
      quantity: params[:quantity].to_i,
      price_cents: (params[:price].to_f * 100).to_i
    )

    # Create outgoing record for the order
    OutgoingRecord.create!(
      record_type: 'order',
      source_id: @order.id,
      data: @order.to_json_rpc_data,
      status: 'pending'
    )

    redirect_to root_path, notice: "Order ##{@order.id} for '#{@order.product_name}' created and queued for sending."
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to root_path, alert: "Failed to create order: #{e.message}"
  end
end
