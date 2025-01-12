# frozen_string_literal: true

require './lib/timeable'
require 'time'

describe Timeable do
  before(:each) do
    class Dummy
      include Timeable
    end

    @dummy = Dummy.new
    @convert1 = 2
    @convert2 = 7
    @convert3 = 5
  end

  describe '#convert_int_to_day' do
    it 'converts a number index value to a day of week string' do
      expect(@dummy.convert_int_to_day(@convert1)).to eq('Tuesday')
      expect(@dummy.convert_int_to_day(@convert2)).to eq(nil)
      expect(@dummy.convert_int_to_day(@convert3)).to eq('Friday')
    end
  end

  describe '#month_to_int' do
    it 'converts a string representing month of the year to equal integer value' do
      expect(@dummy.month_to_int('September')).to eq(9)
      expect(@dummy.month_to_int('March')).to eq(3)
    end
  end

  describe '#time_to_year' do
    it 'converts a time into an integer represting the year in time' do
      expect(@dummy.time_to_year(Time.parse('2012-08-26 20:56:56 UTC'))).to eq(2012)
      expect(@dummy.time_to_year('2012-08-26 20:56:56 UTC')).to eq(2012)
    end
  end

  describe '#same_month?' do
    it 'checks a time value against month integer value for equality' do
      expect(@dummy.same_month?(Time.parse('2012-08-26 20:56:56 UTC'), 8)).to eq(true)
      expect(@dummy.same_month?(Time.parse('2012-05-26 20:56:56 UTC'), 5)).to eq(true)
      expect(@dummy.same_month?('2012-05-26 20:56:56 UTC', 5)).to eq(true)
      expect(@dummy.same_month?(@dummy.convert_to_time('2012-03-26 20:56:56 UTC'), 
        @dummy.month_to_int('March'))).to eq(true)
      expect(@dummy.same_month?(@dummy.convert_to_time('2012-06-26 20:56:56 UTC'), 
        @dummy.month_to_int('March'))).to eq(false)
    end
  end

  describe '#convert_to_time' do
    it 'converts a string in time format to a time object' do
      expect(@dummy.convert_to_time('2012-05-26 20:56:56 UTC')).to eq(Time.parse('2012-05-26 20:56:56 UTC'))
      expect(@dummy.convert_to_time(Time.parse('2012-05-26 20:56:56 UTC'))).to eq(Time.parse('2012-05-26 20:56:56 UTC'))
    end
  end

  describe '#created_at' do
    it 'sets the time of registration' do
      dummy = double('dummy')
      allow(dummy).to receive(:created_at).and_return(Time.parse('2012-05-26 20:56:56 UTC'))
      expect(dummy.created_at).to be_instance_of(Time)
    end
  end

  describe '#updated_at' do
    it 'sets the time of most recent update' do
      dummy = double('dummy')
      allow(dummy).to receive(:updated_at).and_return(Time.parse('2012-05-26 20:56:56 UTC'))
      expect(dummy.updated_at).to be_instance_of(Time)
    end
  end

  describe '#format_time_to_string' do
    it 'converts a time object to a day/month/year formatted string' do
      expect(@dummy.format_time_to_string(Time.parse('2012-05-26 20:56:56 UTC'))).to eq("26/05/2012")
    end
  end
end
