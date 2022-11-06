# frozen_string_literal: true

require_relative 'general_repo'
require_relative 'invoice'
require 'time'

# InvoiceRepo holds, creates, updates, destroys, and finds repository.
class InvoiceRepo < GeneralRepo
  def initialize(data, engine)
    super('Invoice', data, engine)
  end

  def find_all_by_customer_id(id)
    @repository.select { |invoice| invoice.customer_id == id.to_i }
  end

  def find_all_by_merchant_id(id)
    @repository.select { |invoice| invoice.merchant_id == id.to_i }
  end

  def find_all_by_status(status)
    @repository.select { |invoice| invoice.status == status }
  end

  def invoice_status(type)
    count = find_all_by_status(type).count
    total = all.count
    percent(count, total)
  end

  def number_of_invoices_per_day
    days = Hash.new(0)
    @repository.each { |invoice| days[convert_int_to_day(invoice.created_at.wday)] += 1 }
    days
  end

  def average_invoices_per_day
    average(number_of_invoices_per_day.values.sum, number_of_invoices_per_day.count)
  end

  def average_invoices_per_day_standard_deviation
    deviation(number_of_invoices_per_day.values, average_invoices_per_day)
  end

  def top_days_by_invoice_count
    std_dev = average_invoices_per_day_standard_deviation
    day_avg = average_invoices_per_day
    top_days = number_of_invoices_per_day.select do |day, count|
      deviation_difference(std_dev, count, day_avg) > 1
    end
    top_days.keys
  end

  def convert_int_to_day(num)
    days = [
      'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
    ]
    days[num]
  end

  def invoice_paid_in_full?(invoice_id)
    find_by_id(invoice_id).paid?
  end

  def invoice_total(invoice_id)
    find_by_id(invoice_id).total
  end

  def all_invoices_paid_on(date)
    if date.is_a? String
      date_time = Time.parse(date)
    else
      date_time = date
    end
    @repository.select do |invoice|
      invoice.paid? &&
        invoice.created_at.strftime('%d/%m/%Y') == date_time.strftime('%d/%m/%Y')
    end
  end

  def total_revenue_by_date(date)
    all_invoices_paid_on(date).sum do |invoice|
      invoice_total(invoice.id)
    end
  end
end
