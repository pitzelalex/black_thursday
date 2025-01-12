# frozen_string_literal: true

require_relative 'general_repo'
require_relative 'customer'

# Repo for Customer objects, child of general
class CustomerRepo < GeneralRepo
  attr_reader :id,
              :first_name,
              :last_name

  def initialize(customer_data, engine)
    super(Customer, customer_data, engine)
  end

  def find_all_by_first_name(first_name)
    @repository.select { |customer| customer.first_name.downcase.include?(first_name.downcase) }
  end

  def find_all_by_last_name(last_name)
    @repository.select { |customer| customer.last_name.downcase.include? last_name.downcase }
  end
end
