require 'open3'

class VpnConnectionController < ApplicationController
  basic_auth_creds = Rails.configuration.global_settings[:basic_auth]
  http_basic_authenticate_with name: basic_auth_creds[:name], password: basic_auth_creds[:password]

  def create
    if connected?
      message = "Already connected to #{get_country}. Please destroy connection and wait to initiate a new one"
      success = false
    else
      if safe?
        country = params[:country_code]
        message = connect_to_vpn(country)
        success = connected?
      else
        message = "Please wait a few minutes before initiating a new connection"
        success = false
      end
    end

    response[:connected] = success
    response[:message] = message

    render json: response
  end

  def destroy
    if connected?
      Open3.popen3('killall', 'openvpn')
      conn = last_connection
      conn.active = false
      conn.save!
      message = "Connection was destroyed"
    else
      message = "No open connection"
    end

    response[:message] = message
    render json: response
  end

  def status
    response[:connected] = connected?
    response[:last_connected_to] = get_country

    render json: response
  end

  private

  def last_connection
    VpnConnection.last
  end

  def connected?
    last_connection.active
  end

  def get_country
    last_connection.country.code
  end

  def safe?
    Time.now - last_connection.updated_at > Rails.configuration.global_settings[:sleep_time]
  end

end
