class Address < ApplicationRecord
  validates :house_number, :street_name, :city, :state, :zip_5, presence: true
  validates :state, format: { with: /[A-Za-z]{2}/, message: 'should be two letters' }
  validates :zip_5, format: { with: /\A\d{5}\z/, message: 'should be five digits' }

  before_validation do
    return false if self.nil?
  end

  def to_s
    "#{street_address}, #{city}, #{state} #{zip_5}"
  end

  def street_address
    [
      house_number,
      street_predirection,
      street_name,
      street_type,
      street_postdirection,
      unit_type,
      unit_number
    ].compact.join(' ')
  end
end
