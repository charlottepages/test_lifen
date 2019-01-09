require "json"
require "pp"

# Write tests
# Parse JSON
# Retrieve ids of Practitionners with 'express delivery' true (Array of Integer)
# Group Communications by send date (Array of Comms (ruby hashes))
# Then, for each group, sum and convert to € (.fdiv (100)):
  # total nb of Comms * 10 cents
  # nb of colored Comms * 18 cents
  # (total nb of pages - total nb of Comms) * 7 cents
  # nb of Comms with noted practitioner_id * 60 cents
# Store output in JSON

filepath = 'data.json'
serialized_data = File.read(filepath)
data = JSON.parse(serialized_data, symbolize_names: true)

express_delivery_practitioner_ids = data[:practitioners].select { |p| p[:express_delivery] == true }.map { |p| p[:id] }
pp express_delivery_practitioner_ids
