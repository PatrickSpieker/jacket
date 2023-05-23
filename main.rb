# typed: true
require 'nokogiri'
require 'excon'
require 'zlib'
require 'pp'

# This filters for: REI / Men's / Jacket / Size: Medium
RESULTS_URL = "https://www.rei.com/used/shop/mens?brand=REI%20Co-op&size=M&category=Jackets&department=Men%27s%20Clothing"

# fetch results from results URL (need ruby web library)
# headers from successful web-request
headers = {
    "accept" => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    "accept-encoding" => 'gzip, deflate, br',
    "accept-language" => 'en-US,en;q=0.9',
    "cache-control" => 'no-cache',
    "dnt" => '1',
    "pragma" => 'no-cache',
    "sec-ch-ua" => '"Chromium";v="112", "Google Chrome";v="112", "Not:A-Brand";v="99"',
    "sec-ch-ua-mobile" => '?0',
    "sec-ch-ua-platform" => '"macOS',
    "sec-fetch-dest" => 'document',
    "sec-fetch-mode" => 'navigate',
    "sec-fetch-site" => 'same-origin',
    "sec-fetch-user" => '?1',
    "sec-gpc" => '1',
    "upgrade-insecure-requests" => '1',
    "user-agent" => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36',
}
response = Excon.get(RESULTS_URL, :headers => headers)
puts response.status
# pp response.headers
INFLATE_ZLIB_OR_GZIP  = 47 # Zlib::MAX_WBITS + 32
html_response_body_string = Zlib::Inflate.new(INFLATE_ZLIB_OR_GZIP).inflate(response.body)
# Next I want to find the <script> tag that has content that starts with 
# parse the results with Nokogiri HTML parser
# fetch out the ordered list
# look for the Jacket
# print that list out