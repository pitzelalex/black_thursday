# frozen_string_literal: true

require_relative 'general_repo'
require_relative 'invoice_item'

# this is the InvoiceItemRepository class
class InvoiceItemRepository < GeneralRepo
  def initialize(data, se)
    super(InvoiceItem, data, se)
  end

  def find_all_by_item_id(item_id)
    @repository.find_all do |ii|
      ii.item_id == item_id.to_i
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @repository.find_all do |ii|
      ii.invoice_id == invoice_id.to_i
    end
  end
end
