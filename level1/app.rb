require "json"
require "date"
require "pp"

# Parse JSON
filepath = 'data.json'
serialized_data = File.read(filepath)
data = JSON.parse(serialized_data, symbolize_names: true)

# Retrieve ids of Practitionners with 'express delivery' true (Array of Integer)
express_delivery_practitioner_ids = data[:practitioners].select { |p| p[:express_delivery] == true }.map { |p| p[:id] }

# Group Communications by send date (Array of Comms (ruby hashes))
communication_groups = data[:communications].group_by { |c| Date.parse(c[:sent_at]).to_s }

# Calculate total for each group and build output
totals = []
communication_groups.each do |day, comms|
  day_comm_values = comms.map do |comm|
    comm_value_cents = 10
    comm_value_cents += 18 if comm[:color]
    comm_value_cents += (comm[:pages_number] - 1) * 7
    comm_value_cents += 60 if express_delivery_practitioner_ids.include?(comm[:practitioner_id])
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
