Keen = require 'keen-js'
stuff = "is no good oh yeah sdfsdf"

client = new Keen(
  projectId: "54f8c34e59949a7894bb197e"   # String (required always)
  writeKey: "a80164c5c541782f3ffb61f63b30fe8572f2f523546919ec0c083bcda1cc3f77bf01bfb34ae226624f0218ed3c6ac0c100877135e30119beffc7d820ef5c9a65e2ecd7e6cbf7249c48137b41b37c8c66efdb937f6767d8c70d6709c3fb4fa5d2472d7c9e79a556195e97c6882e09eebc"     # String (required for sending data)
  readKey: "38fc26137c9632adad06f5206da6e5462f7b05ec9a39abb42073ac83be3468347b51e949725f5c4fb96027f60a11f3a7e0633b9732544d3fbd79089bc39401cf4923fbe28eab93e6e3bf44c1ad45a3226c6f4198105f79fc7fb40d3ae3124cb418057b4081d2f7f6e08509ff50ff3e7c"       # String (required for querying data)
#  protocol: "https"              # String (optional: https | http | auto)
#  host: "api.keen.io/3.0"        # String (optional)
#  requestType: "jsonp"            # String (optional: jsonp, xhr, beacon)
)

#purchaseEvent =
#  item: 'golden gadget'
#  price: 60.50
#  referrer: document.referrer
#  keen: timestamp: (new Date).toISOString()
#
## Send it to the "purchases" collection
#client.addEvent 'purchases', purchaseEvent, (err, res) ->
#  console.debug res
#  if err
#    # there was an error!
#  else
#    # see sample response below
#  return

app = require './app'
console.debug 'app', app

count = new (Keen.Query)('count', eventCollection: 'purchases')
client.draw count, document.getElementById('count-pageviews-metric'),
  chartType: 'metric'
  title: 'Total Pageviews'
  colors: [ '#49c5b1' ]

visitor_origins = new (Keen.Query)('count',
  eventCollection: 'purchases'
  groupBy: 'price')
client.draw visitor_origins, document.getElementById('count-pageviews-piechart'),
  chartType: 'piechart'
  title: 'Visitor Referrers'

total_pageviews = new (Keen.Query)('count',
  eventCollection: 'purchases'
  groupBy: 'price'
  timeframe: 'this_3_days'
  interval: 'daily')

client.draw total_pageviews, document.getElementById('total-daily-revenue-linechart'),
  chartType: 'linechart'
  title: 'Daily revenue (7 days)'
