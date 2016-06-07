class Order < ActiveRecord::Base
	validates :address, :city, :state, presence: true
	validates :listing_id, uniqueness: { message: "has already been ordered." }
	belongs_to :listing
	belongs_to :buyer, class_name: "User"
  	belongs_to :seller, class_name: "User"

  	default_scope -> { order(created_at: :desc) }

  	protected

  	def self.dup_check(listing)
  		where(listing_id: listing).present?
  	end
end
