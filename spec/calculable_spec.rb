# frozen_string_literal: true

require './lib/calculable'
require 'bigdecimal'

describe Calculable do
  before(:each) do
    @convert1 = '1200'
    @convert2 = 12.50
    @convert3 = BigDecimal(1000, 4)
    @convert4 = 1500

    @average1 = [30, 5]
    @average2 = [72, 10]

    @percent1 = [72, 100]
    @percent2 = [5, 10]
    @percent3 = [10, 1500]
    @percent4 = [10, 10]

    @deviation1 = [3,4,5]
    @deviation2 = [15,12,20]
    @deviation3 = [25,16,2]
  end

  describe '#price_converter' do
    it 'converts a number from string or integer to a float representation' do
      expect(Calculable.price_converter(@convert1)).to eq("12.00")
      expect(Calculable.price_converter(@convert2)).to eq("12.5")
      expect(Calculable.price_converter(@convert3)).to eq("0.1e4")
      expect(Calculable.price_converter(@convert4)).to eq("15.00")
    end
  end

  describe '#average' do
    it 'calculates the mean average of the sum and count' do
      expect(Calculable.average(@average1[0], @average1[1])).to eq(6)
      expect(Calculable.average(@average2[0], @average2[1])).to eq(7.2)
    end
  end

  describe '#deviation' do
    it 'calculates the sample deviation of a set of numbers and the mean average' do
      expect(Calculable.deviation(@deviation1)).to eq(1)
      expect(Calculable.deviation(@deviation2)).to eq(4.041451884327381)
      expect(Calculable.deviation(@deviation3)).to eq(11.590225767142474)
    end
  end

  describe '#percent' do
    it 'calculates the percentage of a value and the total value' do
      expect(Calculable.percent(@percent1[0], @percent1[1])).to eq(72)
      expect(Calculable.percent(@percent2[0], @percent2[1])).to eq(50)
      expect(Calculable.percent(@percent3[0], @percent3[1])).to eq(0.67)
      expect(Calculable.percent(@percent4[0], @percent4[1])).to eq(100)
    end
  end
end
