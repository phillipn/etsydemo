class Listing < ActiveRecord::Base
	has_attached_file :image, :styles => { :medium => "100x100", :thumb => "50x50>" }, :default_url => "default.jpg"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
