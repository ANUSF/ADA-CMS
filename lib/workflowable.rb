module Workflowable
	attr_accessor :transition_to

	PUBLISH = "publish"
	DRAFT 	= "draft"

	def self.included(base)
		base.send("before_save", :draft!, :unless => "transition_to == PUBLISH")
	end

	def publish!(user)
		if user.can_approve?
			self.state = PUBLISH
			self.transition_to = PUBLISH
			save!
		else
			false
		end
	end

	def draft!
		self.state = DRAFT
		self.transition_to = DRAFT
	end

	def published?
		self.state == PUBLISH
	end

	def draft?
		not published?
	end
end