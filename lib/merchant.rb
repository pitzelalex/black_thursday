# frozen_string_literal: true
require 'calculable'
# This is the Merchant Class
class Merchant
  include Calculable
  attr_reader :id,
              :name

  def initialize(data, repo)
    @id   = (data[:id]).to_i
    @name = data[:name]
    @merchant_repo = repo
  end

  def update(name)
    @name = name[:name]
  end

  # Fetches items owned by merchant
  def _items
    @_items ||= @merchant_repo.engine.items.find_all_by_merchant_id(@id)
  end

  # Returns number of items owned by merchant.
  def item_count
    _items.count
  end

  # Returns an array of item prices owned by merchant.
  def item_prices
    _items.map do |item|
      item.unit_price
    end
  end

  def _invoices
    @_invoices ||= @merchant_repo.engine.invoices.find_all_by_merchant_id(@id)
  end

  def invoice_count
    _invoices.count
  end

  def avg_item_price
    average(item_prices.sum, item_count)
  end

  def invoice_pending?
    _invoices.any? { |invoice| !(invoice.paid?) }
  end

  def revenue
    paid_inv = _invoices.select { |invoice| invoice.paid? }
    paid_inv.sum { |invoice| invoice.total }
  end
end
