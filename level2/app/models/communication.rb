class Communication < ApplicationRecord
  belongs_to :practitioner

  def as_json(options = nil)
    {
      first_name: self.practitioner.first_name,
      last_name: self.practitioner.last_name,
      sent_at: sent_at
    }
  end

end
