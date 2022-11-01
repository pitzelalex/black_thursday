require 'rspec'
require './lib/merchant'

describe Merchant do
  describe '#initialize' do
    before(:each) do
      @merchant = Merchant.new({:id => 5, :name => "Turing School"})
    end

    it 'is an instance of Merchant' do
      expect(@merchant).to be_a Merchant
    end

    it 'stores the merchants name' do
      expect(@merchant.name).to eq("Turing School")
    end
    
    it 'stores the merchants id' do
      expect(@merchant.id).to eq(5)
    end

    it 'stores a different name and id' do
      merchant = Merchant.new({:id => 10, :name => "Frankenstein and Sons"})

      expect(merchant.name).to eq("Frankenstein and Sons")
      expect(merchant.id).to eq(10)
    end
  end
end