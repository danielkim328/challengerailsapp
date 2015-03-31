class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	after_filter :cors_set_access_control_headers

	# For all responses in this controller, return the CORS access control headers.

	def cors_set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
		headers['Access-Control-Allow-Headers'] = '*'
		headers['Access-Control-Request-Method'] = '*'
	end
	
end
