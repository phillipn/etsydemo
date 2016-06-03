module ApplicationHelper
	def full_title(title)
		if title.empty?
			"EtsyDemo"
		else
			"#{title} | EtsyDemo"
		end
	end
end
