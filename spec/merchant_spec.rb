# frozen_string_literal: true

require 'rspec'
require './lib/merchant'

describe Merchant do
  let(:merchant) { Merchant.new({ id: 5, name: 'Turing School' }, 'm_repo') }
  describe '#initialize' do
    it 'is an instance of Merchant' do
      expect(merchant).to be_a Merchant
    end

    it 'stores the merchants name' do
      expect(merchant.name).to eq('Turing School')
    end

    it 'stores the merchants id' do
      expect(merchant.id).to eq(5)
    end

    it 'stores a different name and id' do
      merchant = Merchant.new({ id: 10, name: 'Frankenstein and Sons' }, 'mr')

      expect(merchant.name).to eq('Frankenstein and Sons')
      expect(merchant.id).to eq(10)
    end
  end

  describe '#update' do
    it 'changes the @name of the Merchant' do
      merchant.update({ name: 'Test' })

      expect(merchant.name).to eq('Test')
    end
  end

  describe '#_items' do
    it 'fetches items owned by merchant' do
      merch_repo = double('merch_repo')
      merchant = Merchant.new({ id: 5, name: 'Turing School' }, merch_repo)
      allow(merch_repo).to receive(:send_to_engine).and_return(['item1', 'item2'])
      expect(merchant._items).to eq ['item1', 'item2']
    end
  end

  describe '#item_count' do
    it 'returns the number of items a merchant owns' do
      allow(merchant).to receive(:_items).and_return(['item1', 'item2'])
      expect(merchant.item_count).to eq(2)
    end
  end

  describe '#item_prices' do
    it 'returns the number of items a merchant owns' do
      item1 = double('item1')
      item2 = double('item2')
      allow(item1).to receive(:unit_price).and_return(1)
      allow(item2).to receive(:unit_price).and_return(3)
      allow(merchant).to receive(:_items).and_return([item1, item2])
      expect(merchant.item_prices).to eq([1, 3])
    end
  end

  describe '#avg_item_price' do
    it 'returns the average price of the merchants items' do
      item1 = double('item1')
      item2 = double('item2')
      allow(item1).to receive(:unit_price).and_return(1)
      allow(item2).to receive(:unit_price).and_return(3)
      allow(merchant).to receive(:_items).and_return([item1, item2])
      expect(merchant.item_prices).to eq([1, 3])
      expect(merchant.avg_item_price).to eq 2.0
    end
  end

  describe '#_invoices' do
    it 'fetches invoices created by merchant' do
      merch_repo = double('merch_repo')
      merchant = Merchant.new({ id: 5, name: 'Turing School' }, merch_repo)
      allow(merch_repo).to receive(:send_to_engine).and_return(['invoice1', 'invoice2'])
      expect(merchant._invoices).to eq ['invoice1', 'invoice2']
    end
  end

  describe '#invoice_count' do
    it 'returns the number of invoices a merchant keeps' do
      allow(merchant).to receive(:_invoices).and_return(['invoice1', 'invoice2'])
      expect(merchant.invoice_count).to eq(2)
    end
  end

  describe '#invoice_pending?' do
    it 'returns whether or not the merchant has a pending invoice' do
      invoice1 = double('invoice1')
      invoice2 = double('invoice2')
      allow(merchant).to receive(:_invoices).and_return([invoice1, invoice2])
    end
  end

  describe '#revenue' do
    it 'returns the sum of all paid in full invoices' do
      inv1 = double('inv1')
      inv2 = double('inv2')
      inv3 = double('inv3')
      inv4 = double('inv4')
      inv5 = double('inv5')
      allow(merchant).to receive(:_invoices).and_return([inv1, inv2, inv3, inv4, inv5])
      allow(inv1).to receive(:paid?).and_return true
      allow(inv2).to receive(:paid?).and_return false
      allow(inv3).to receive(:paid?).and_return true
      allow(inv4).to receive(:paid?).and_return false
      allow(inv5).to receive(:paid?).and_return true
      allow(inv1).to receive(:total).and_return(2000)
      allow(inv2).to receive(:total).and_return(10000)
      allow(inv3).to receive(:total).and_return(6500)
      allow(inv4).to receive(:total).and_return(20000)
      allow(inv5).to receive(:total).and_return(1500)

      expect(merchant.revenue).to eq(10000)
    end
  end
end
