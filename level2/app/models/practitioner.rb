class Practitioner < ApplicationRecord
  has_many :communications, dependent: :destroy
end
