require 'rails_helper'

RSpec.describe Address, :type => :model do
  describe '#new' do
    context 'Given a valid address' do
      it 'can create a new address' do
        expect(Address.new(house_number: 1600,
                           street_name: 'Pennsylavnia',
                           street_type: 'Avenue',
                           street_postdirection: 'NW',
                           city: 'Washington',
                           state: 'DC',
                           zip_5: 20500)).to be_valid
      end
    end

    context 'Given bad address values' do
      it 'cannot create a new address' do
        expect(Address.new(house_number: 1600,
                           street_name: 'Pennsylavnia',
                           street_type: 'Avenue',
                           street_postdirection: 'NW',
                           city: 'Washington',
                           state: 'DC',
                           zip_5: 123)).not_to be_valid
      end
    end

    describe '#to_s' do
      let(:address) { create(:address_ny) }
      it 'prints out the address components needed for mailing together as a string' do
        expect(address.to_s).to eq('129 W 81st St Apt 5A, New York, NY 10024')
      end

      let(:address2) do
        create(:address_ny, street_postdirection: 'SE',
                            street_predirection: nil)
      end

      it 'prints out the address components with appropriate spacing' do
        expect(address2.to_s).to eq('129 81st St SE Apt 5A, New York, NY 10024')
      end

      let(:address3) do
        create(:address_ny, street_postdirection: nil,
                            street_predirection: nil,
                            unit_number: nil,
                            unit_type: nil)
      end

      it 'prints out the address components with appropriate spacing with nil elements' do
        expect(address3.to_s).to eq('129 81st St, New York, NY 10024')
      end

      let(:address4) do
        create(:address_ny, street_type: nil,
                            street_postdirection: nil,
                            street_predirection: nil,
                            unit_number: nil,
                            unit_type: nil,
                            zip_5: '01230')
      end

      it 'prints out the address components with appropriate spacing with nil elements' do
        expect(address4.to_s).to eq('129 81st, New York, NY 01230')
      end
    end
  end
end
