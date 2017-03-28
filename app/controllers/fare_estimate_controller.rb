class FareEstimateController < ApplicationController
  include FareEstimate
  include ErrorMessage

  def calculate_fare
    valid_location?(params[:source], params[:destination], params[:cab_type])
    if @error.nil?
      distance = calculate_distance(params[:source].split(','), params[:destination].split(',')).round(2)
      cab_type = CabType.find(params[:cab_type])
      fare = calculate_fare_estimate(distance, cab_type).round(2)
      tax = calculate_tax(fare).round(2)
      total = (fare + tax)
      render json: { distance: distance, fare: fare, tax: tax, total: total,
                     cab_type: cab_type.name, max_persons: cab_type.number_of_persons }.to_json, status: 200
    else
      render json: {
        error: @error
      }.to_json, status: 420
    end
  end
end
