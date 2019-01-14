# rake test_create:init

namespace 'test_create' do
  task init: :environment do
    Practitioner.destroy_all

    total_practitioners = 300
    max_communications = 9000

    total_practitioners.times do
      name = Faker::Name.name.split ' '
      Practitioner.create(first_name: name.first, last_name: name.last)
    end

    practitioner = Practitioner.all.sample
    first_name = practitioner.first_name
    last_name = practitioner.last_name

    start = Time.now
    max_communications.times do
      practitioner = Practitioner.find_by(first_name: first_name, last_name: last_name)

      communication = Communication.new(practitioner: practitioner, sent_at: Time.at(rand * Time.now.to_f))

      puts communication.as_json if communication.save
    end
    puts Time.now - start
  end
end
