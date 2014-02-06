# encoding: utf-8
module ApplicationHelper
	def full_title(page_title)
		base_title = "基于Ruby on Rails的微博"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	def error_div(model,field,field_name)
		return unless model
		field = field.is_a?(Symbol) ? field.to_s : field
		errors = model.errors[field]
		return unless errors
		%Q(
			<div class="errors">
			#{errors.is_a?(Array) ? errors.map{ |e| field_name + e}.join(",") : field_name << errors}
			</div>
		)
	end
end
