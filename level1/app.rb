require 'json'
require 'date'

# DOMAIN VARIABLES
BASE_PRICE = 10
COLOR_PRICE = 18
EXTRA_PAGE_PRICE = 7
EDP_PRICE = 60

# Parse JSON
filepath = 'data.json'
serialized_data = File.read(filepath)
data = JSON.parse(serialized_data, symbolize_names: true)

# Retrieve ids of Express Delivery Practitioners (EDP's)
edps = data[:practitioners].select { |p| p[:express_delivery] }
edp_ids = edps.map { |p| p[:id] }

# Group Communications by send date
comm_groups = data[:communications].group_by { |c| Date.parse(c[:sent_at]).to_s }

# Calculate total for each group of Communications and build output
totals = []
comm_groups.each do |day, comms|
  day_comm_values = comms.map do |comm|
    comm_value_cents = BASE_PRICE
    comm_value_cents += COLOR_PRICE if comm[:color]
    comm_value_cents += (comm[:pages_number] - 1) * EXTRA_PAGE_PRICE
    comm_value_cents += EDP_PRICE if edp_ids.include?(comm[:practitioner_id])
    comm_value_cents
  end
  totals.push(
    sent_on: day,
    total: day_comm_values.sum.fdiv(100)
  )
end
my_output = { totals: totals }

# Store in JSON
File.open('my_output.json', 'wb') do |file|
  file.write(JSON.pretty_generate(my_output))
end
