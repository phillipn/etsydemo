class Listing < ActiveRecord::Base
  default_scope -> { order(created_at: :desc) }
  
  if Rails.env.development?
    has_attached_file :image, :styles => { :medium => "200x", :thumb => "100x100>" }, :default_url => "default.jpg"
  else
    has_attached_file :image, :styles => { :medium => "200x", :thumb => "100x100>" }, :default_url => "default.jpg",
        :storage => :dropbox,
        :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
        :path => ":style/:id_:filename"
  end

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates :name, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  belongs_to :user
  has_one :order
  belongs_to :category
end
