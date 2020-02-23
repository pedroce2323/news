require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "36bcaff1a7e63e08e2e815ec90156c5b"

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
  # do everything else
    results = Geocoder.search(params["location"])
    lat_lng = results.first.coordinates
    @lat = "#{lat_lng[0]}"
    @lng = "#{lat_lng[1]}"


    # # do the heavy lifting, use Global Hub lat/long
    forecast = ForecastIO.forecast("#{@lat}", "#{@lng}").to_hash
    
    @current_temp = forecast["currently"]["temperature"]
    @current_summary = forecast["currently"]["summary"]


    i=1

    @forecast_array = []

    for days in forecast["daily"]["data"]
        @forecast_array << "Day #{i}: A high temperature of #{days["temperatureHigh"]} and #{days["summary"]}"
        i = i + 1
    end

    puts @forecast_array

    view "news"
end