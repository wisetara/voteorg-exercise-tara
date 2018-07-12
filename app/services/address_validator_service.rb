class AddressValidatorService

  attr_accessor :address, :elements, :result

  DIRECTIONS = %w[N NW NE S SW SE E W]
  FULL_DIRECTIONS = %w[North Northwest Northeast South Southwest Southeast East West]

  def initialize(address)
    @address = address
    @elements = address.split(/ /)
    @result = geocoder_result
  end

  def geocode_parse
    return false unless valid_to_continue?
    required_fields = [result[:locality_long],
                       result[:administrative_area_level_1_short],
                       result[:postal_code_long],
                       result[:street_number_long],
                       result[:route_long]]
    return false unless required_fields.compact.length == 5
    {
      city: result[:locality_long],
      state: result[:administrative_area_level_1_short],
      zip_5: result[:postal_code_long]
    }.merge(street_address)
  end

  def street_address
    house_number, housenumber, street_predirection, predirection_long,
      predirection_short, street_name, streetname, street_type, streettype,
      street_postdirection, postdirection_short, postdirection_long,
      unit_type, unit_number = ''

    housenumber = result[:street_number_long] if result[:street_number_long]
    streetname = get_streetname
    streettype = get_streettype
    predirection = @predirection_short
    postdirection = @postdirection_short
    unitnumber = result[:subpremise_long] if result[:subpremise_long]
    unittype = get_unittype(housenumber, streetname, streettype, unitnumber)

    {
      house_number: housenumber,
      street_predirection: predirection,
      street_name: streetname,
      street_type: streettype,
      street_postdirection: postdirection,
      unit_type: unittype,
      unit_number: unitnumber
    }
  end

  def valid_to_continue?
    return false if address.nil? || address.empty?
    true
  end

  def geocoder_result
    new_hash = {}
    result = Geocoder.search(address)
    result[0].data['address_components'].each do |component_hash|
      key = component_hash['types'].first
      key_long = (key + '_long').to_sym
      key_short = (key + '_short').to_sym
      new_hash[key_long] = component_hash['long_name']
      new_hash[key_short] = component_hash['short_name']
    end
    new_hash
  end

  def get_streetname
    streetname = result[:route_short] if result[:route_short]

    @predirection_short = DIRECTIONS.include?(streetname.slice(0..1)) ? streetname.slice(0..1) : ''
    @postdirection_short = DIRECTIONS.include?(streetname[-2..-1]) ? streetname[-2..-1] : ''

    pre_pattern = /^[A-Z]{2}\s/
    post_pattern = /\s[A-Z]{2}$/

    streetname_with_type = streetname.gsub(pre_pattern, '') if @predirection_short != ''
    streetname_with_type = streetname.gsub(post_pattern, '') if @postdirection_short !=''
    streetname_with_type.partition(" ").first
  end

  def get_streettype
    streetname_long = result[:route_long] if result[:route_long]
    streetname_first = streetname_long.split(' ').first
    streetname_last = streetname_long.split(' ').last

    @predirection_long = FULL_DIRECTIONS.include?(streetname_first) ? streetname_first : ''
    @postdirection_long = FULL_DIRECTIONS.include?(streetname_last) ? streetname_last : ''

    streetname_long_with_type = streetname_long.split(' ')[1..-1].join(' ') if @predirection_long!= ''
    streetname_long_with_type = streetname_long.split(' ')[0..-2].join(' ') if @postdirection_long != ''

    streetname_long_with_type.split(' ').last
  end

  def get_unittype(housenumber, streetname, streettype, unitnumber)
    components = [@predirection_long, @predirection_short, @postdirection_long, @postdirection_short, housenumber, streetname, streettype, result[:locality_long], unitnumber, result[:postal_code_long], result[:administrative_area_level_1_short]].reject!(&:blank?)

    new_address = []
    address.split(' ').each do |component|
      component = '' if components.include?(component)
      new_address << component
    end
    unittype = new_address.reject!(&:empty?).join(' ')
  end
end
