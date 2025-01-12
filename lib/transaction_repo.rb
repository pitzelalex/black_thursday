# frozen_string_literal: true

require_relative 'transaction'
require_relative 'general_repo'

# This is the transaction_repository class
class TransactionRepo < GeneralRepo
  def initialize(data, engine)
    super(Transaction, data, engine)
  end

  def find_all_by_invoice_id(id)
    @repository.select { |item| item.invoice_id == id.to_i }
  end

  def find_all_by_credit_card_number(card_number)
    @repository.select { |item| item.credit_card_number == card_number }
  end

  def find_all_by_result(result)
    @repository.select { |item| item.result == result }
  end
end
