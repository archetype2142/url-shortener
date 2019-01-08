class Url < ApplicationRecord 
	validates :short_url, presence: true, uniqueness: true
	validates_format_of :original_url, :with => /[\S]+/
end
