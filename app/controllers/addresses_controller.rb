require 'address_validator_service'

class AddressesController < ApplicationController
  def index
    render 'new'
  end

  def new;
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      flash.now[:notice] = 'You totes saved that address! Enter another?'
      render 'new'
    else
      flash.now[:error] = 'Oh noes! That address may not be valid. Give it another go.'
      render 'new', :status => 422
    end
  end

  private

  def address_params
    permitted_params = params.permit(:street_address, :city, :state, :zip_code)
    permitted_params = permitted_params.values.join(' ')
    AddressValidatorService.new(permitted_params).geocode_parse
  end
end
