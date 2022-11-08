require 'rspec'
require 'csv'
require './lib/merchant_repository'
require './lib/general_repo'

describe MerchantRepository do
  let(:data) { CSV.open './data/merchants_test.csv', headers: true, header_converters: :symbol }
  let(:mr) { MerchantRepository.new(data, "salesengine") }

  describe '#initialize' do
    xit 'is and instance of MerchantRepository' do
      expect(mr).to be_a MerchantRepository
    end

    xit 'can store an array of merchants' do
      m1 = mr.repository[0]
      m2 = mr.repository[1]
      m3 = mr.repository[2]
      m4 = mr.repository[3]
      expect(mr.repository).to eq([m1, m2, m3, m4])
    end
  end

  describe '#create' do
    xit 'creates a Merchant and adds object to @merchants' do
      expect(mr.repository[0].id).to eq(12334105)
      expect(mr.repository[1].id).to eq(12334112)
      expect(mr.repository[2].id).to eq(12334113)
      expect(mr.repository[3].id).to eq(12334115)
      expect(mr.repository[0].name).to eq('Shopin1901')
      expect(mr.repository[1].name).to eq('Candisart')
      expect(mr.repository[2].name).to eq('MiniatureBikez')
      expect(mr.repository[3].name).to eq('LolaMarleys')
    end
  end

  describe '#all' do
    xit 'returns an array of all known Merchant instances' do
      expect(mr.all).to be_a Array
      expect(mr.all).to eq(mr.repository)
    end
  end

  describe '#find_by_id' do
    xit 'returns nil or a Merchant instance that matches id' do
      expect(mr.find_by_id(12334112)).to eq(mr.repository[1])
      expect(mr.find_by_id(2)).to be nil
    end
  end

  describe '#find_by_name' do
    xit 'returns nil or a Merchant instance that matches by name regardless of case' do
      expect(mr.find_by_name('shopin1901')).to eq(mr.repository[0])
      expect(mr.find_by_name('nadda')).to be nil
    end
  end

  describe '#find_all_by_name' do
    xit 'returns an array of all Merchant instances that include the argument' do
      expect(mr.find_all_by_name('s')).to eq([mr.repository[0], mr.repository[1], mr.repository[3]])
      expect(mr.find_all_by_name('test')).to eq([])
      expect(mr.find_all_by_name('SHOP')).to eq([mr.repository[0]])
    end
  end

  describe '#update' do
    xit 'updates the Merchant instance that matches the id with the provided name' do
      mr.update(12334115, { name: 'UpdatedMarleys' })
      expect(mr.find_by_id(12334115).name).to eq('UpdatedMarleys')
    end
  end

  describe '#delete' do
    xit 'removes a Merchant instance with the corresponding id' do
      mr.delete(12334113)
      expect(mr.repository.count).to eq(3)
      expect(mr.repository[2].id).to eq(12334115)
    end
  end

  describe '#number_of_items_per_merchant' do
    xit 'returns the number of items per merchant' do
      allow(mr.all[0]).to receive(:item_count).and_return(1)
      allow(mr.all[1]).to receive(:item_count).and_return(2)
      allow(mr.all[2]).to receive(:item_count).and_return(3)
      allow(mr.all[3]).to receive(:item_count).and_return(1)

      expect(mr.number_of_items_per_merchant).to eq [1, 2, 3, 1]
    end
  end

  describe '#average_items_per_merchant' do
    xit 'returns the average number of items per merchant' do
      allow(mr.all[0]).to receive(:_items).and_return(['item'])
      allow(mr.all[1]).to receive(:_items).and_return(['item1', 'item2'])
      allow(mr.all[2]).to receive(:_items).and_return(['item', 'item2', 'item3'])
      allow(mr.all[3]).to receive(:_items).and_return(['item'])

      expect(mr.average_items_per_merchant).to eq 1.75
    end
  end

  describe '#average_items_per_merchant_standard_deviation' do
    xit 'returns the deviation for average number of items per mechant' do
      allow(mr.all[0]).to receive(:_items).and_return(['item'])
      allow(mr.all[1]).to receive(:_items).and_return(['item1', 'item2'])
      allow(mr.all[2]).to receive(:_items).and_return(['item', 'item2', 'item3'])
      allow(mr.all[3]).to receive(:_items).and_return(['item'])
      expect(mr.average_items_per_merchant_standard_deviation).to eq 0.96
    end
  end

  describe '#number_of_invoices_per_merchant' do
    xit 'returns the number of invoices per merchant' do
      allow(mr.all[0]).to receive(:_invoices).and_return(['invoice1'])
      allow(mr.all[1]).to receive(:_invoices).and_return(['invoice1', 'invoice2'])
      allow(mr.all[2]).to receive(:_invoices).and_return(['invoice1', 'invoice2', 'invoice3'])
      allow(mr.all[3]).to receive(:_invoices).and_return(['invoice1'])

      expect(mr.number_of_invoices_per_merchant).to eq [1, 2, 3, 1]
    end
  end

  describe '#average_invoices_per_merchant' do
    xit 'returns the average number of invoices per merchant' do
      allow(mr.all[0]).to receive(:_invoices).and_return(['invoice1'])
      allow(mr.all[1]).to receive(:_invoices).and_return(['invoice1', 'invoice2'])
      allow(mr.all[2]).to receive(:_invoices).and_return(['invoice1', 'invoice2', 'invoice3'])
      allow(mr.all[3]).to receive(:_invoices).and_return(['invoice1'])

      expect(mr.average_invoices_per_merchant).to eq 1.75
    end
  end

  describe '#average_invoice_per_merchant_standard_deviation' do
    xit 'returns the deviation for average number of invoices per mechant' do
      allow(mr.all[0]).to receive(:_invoices).and_return(['invoice1'])
      allow(mr.all[1]).to receive(:_invoices).and_return(['invoice1', 'invoice2'])
      allow(mr.all[2]).to receive(:_invoices).and_return(['invoice1', 'invoice2', 'invoice3'])
      allow(mr.all[3]).to receive(:_invoices).and_return(['invoice1'])
      expect(mr.average_invoices_per_merchant_standard_deviation).to eq 0.96
    end
  end

  describe '#top_merchants_by_invoice_count' do
    it 'returns a collection of the merchants with a high deviation to the average' do
      mr5 = mr.create(id: 5, name: "Dale")
      mr6 = mr.create(id: 6, name: "Dick")
      mr7 = mr.create(id: 7, name: "Doug")
      allow(mr.all[0]).to receive(:invoice_count).and_return(2)
      allow(mr.all[1]).to receive(:invoice_count).and_return(2)
      allow(mr.all[2]).to receive(:invoice_count).and_return(2)
      allow(mr.all[3]).to receive(:invoice_count).and_return(2)
      allow(mr.all[4]).to receive(:invoice_count).and_return(2)
      allow(mr.all[5]).to receive(:invoice_count).and_return(2)
      allow(mr.all[6]).to receive(:invoice_count).and_return(6)

      expect(mr.top_merchants_by_invoice_count).to eq([mr.all[6]])
    end
  end

  describe '#bottom_merchants_by_invoice_count' do
    it 'returns a collection of the merchants with a low deviation to the average' do
      mr5 = mr.create(id: 5, name: "Dale")
      mr6 = mr.create(id: 6, name: "Dick")
      mr7 = mr.create(id: 7, name: "Doug")
      allow(mr.all[0]).to receive(:invoice_count).and_return(2)
      allow(mr.all[1]).to receive(:invoice_count).and_return(6)
      allow(mr.all[2]).to receive(:invoice_count).and_return(6)
      allow(mr.all[3]).to receive(:invoice_count).and_return(6)
      allow(mr.all[4]).to receive(:invoice_count).and_return(6)
      allow(mr.all[5]).to receive(:invoice_count).and_return(6)
      allow(mr.all[6]).to receive(:invoice_count).and_return(6)

      expect(mr.bottom_merchants_by_invoice_count).to eq([mr.all[0]])
    end
  end

  describe '#merchants_with_high_item_count' do
    xit 'returns an array of merchants whos item count is greater than 1 standard deviation' do
      allow(mr.all[0]).to receive(:_items).and_return(['item'])
      allow(mr.all[1]).to receive(:_items).and_return(['item1', 'item2'])
      allow(mr.all[2]).to receive(:_items).and_return(['item', 'item2', 'item3', 'item4', 'item5', 'item6', 'item7'])
      allow(mr.all[3]).to receive(:_items).and_return(['item'])
      expect(mr.merchants_with_high_item_count).to eq([mr.all[2]])
    end
  end

  describe '#average_item_price_for_merchant' do
    xit 'returns the average item price for the given merchant id' do
      allow(mr.all[0]).to receive(:avg_item_price).and_return(2.0)
      expect(mr.average_item_price_for_merchant(12_334_105)).to eq(2.0)
    end
  end

  describe '#average_average_price_per_merchant' do
    xit 'returns the average of merchants average item price' do
      allow(mr.all[0]).to receive(:avg_item_price).and_return(1.0)
      allow(mr.all[1]).to receive(:avg_item_price).and_return(2.2)
      allow(mr.all[2]).to receive(:avg_item_price).and_return(3.6)
      allow(mr.all[3]).to receive(:avg_item_price).and_return(7.4)
      expect(mr.average_average_price_per_merchant).to eq 3.55
    end
  end

  describe '#merchants_with_only_one_item' do
    xit 'returns a collection of merchants who only have one item' do
      allow(mr.all[0]).to receive(:item_count).and_return(1.0)
      allow(mr.all[1]).to receive(:item_count).and_return(2.0)
      allow(mr.all[2]).to receive(:item_count).and_return(4.0)
      allow(mr.all[3]).to receive(:item_count).and_return(7.0)
      expect(mr.merchants_with_only_one_item).to eq([mr.all[0]])
    end
  end

  describe '#merchants_with_only_one_item_registered_in_month' do
    xit 'returns a collection of merchants who only have one item' do
      allow(mr.all[0]).to receive(:item_count).and_return(1.0)
      allow(mr.all[1]).to receive(:item_count).and_return(2.0)
      allow(mr.all[2]).to receive(:item_count).and_return(4.0)
      allow(mr.all[0]).to receive(:created_at).and_return(Time.parse('2012-03-26 20:56:56 UTC'))
      allow(mr.all[1]).to receive(:created_at).and_return(Time.parse('2012-06-26 20:56:56 UTC'))
      allow(mr.all[2]).to receive(:created_at).and_return(Time.parse('2012-09-26 20:56:56 UTC'))
      allow(mr).to receive(:merchants_with_only_one_item).and_return([mr.all[0]])
      expect(mr.merchants_with_only_one_item_registered_in_month('March')).to eq([mr.all[0]])
    end
  end
  
  describe '#merchants_with_pending_invoices' do
    xit 'returns an array of merchants with pending invoices' do
      allow(mr.all[0]).to receive(:invoice_pending?).and_return(true)
      allow(mr.all[1]).to receive(:invoice_pending?).and_return(false)
      allow(mr.all[2]).to receive(:invoice_pending?).and_return(false)
      allow(mr.all[3]).to receive(:invoice_pending?).and_return(true)
      expect(mr.merchants_with_pending_invoices).to eq ([mr.all[0], mr.all[3]])
    end
  end

  describe '#top_revenue_earners' do
    xit 'returns an array of x merchants ranked by revenue' do
      allow(mr.all[0]).to receive(:revenue).and_return(30000)
      allow(mr.all[1]).to receive(:revenue).and_return(5000)
      allow(mr.all[2]).to receive(:revenue).and_return(60000)
      allow(mr.all[3]).to receive(:revenue).and_return(25000)
      m1 = mr.repository[0]
      m2 = mr.repository[1]
      m3 = mr.repository[2]
      m4 = mr.repository[3]

      expect(mr.top_revenue_earners(2)).to eq([m3, m1])
      expect(mr.top_revenue_earners(3)).to eq([m3, m1, m4])
      expect(mr.top_revenue_earners(4)).to eq([m3, m1, m4, m2])
    end
  end

  describe '#revenue_by_merchant' do
    xit 'returns the total revenue of a given merchant' do
      allow(mr.all[0]).to receive(:revenue).and_return(30000)
      
      expect(mr.revenue_by_merchant('12334105')).to eq(30000)
    end
  end
end
