require 'open3'

module VpnConnectionHelper
  def connect_to_vpn(country_code)
    country = Country.find_by(code: country_code)
    if country.present? && country.hma_string.present?
      Open3.popen3('kilall', 'openvpn')
      Open3.popen3('bash', 'hma-vpn.sh', '-p', 'tcp', country.hma_string)
      message = `curl http://geoip.hidemyass.com/ip/`
      "Your IP is #{message}"
    else
      "No country information found. Please add the country"
    end
  end
end
