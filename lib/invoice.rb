# Invoice data class, can update status and time updated.
# frozen_string_literal: true.
class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at

  def initialize(data = {})
    @id          = data[:id]
    @customer_id = data[:customer_id]
    @merchant_id = data[:merchant_id]
    @status      = data[:status]
    @created_at  = data[:created_at]
    @updated_at  = data[:updated_at]
  end

  def change_status(status)
    @status = status
  end

  def update
    @updated_at = Time.now
  end
end