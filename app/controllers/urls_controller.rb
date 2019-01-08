class UrlsController < ApplicationController
	def index
		@url = Url.new
	end

	def create
		@url = Url.new(permitted_params)
		respond_to do |format|
			if @url.save
				format.html { redirect_to root_path, notice: "#{request.base_url + '/' + @url.short_url}" }
	   	 	else
	   	 		format.html { redirect_to root_path, notice: "Incorrect URL" }	
	   	 	end
   	 	end
	end

	def show
		@url = Url.where(short_url: params[:short_url])
		render template: '/urls/404' unless @url.size > 0
		redirect_to @url[0].original_url if @url.size > 0
	end

private
	def permitted_params
	{
		original_url: sanitize(params[:url]),
		short_url: short_url_generator
	}
	end

	def short_url_generator
		o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
		(0...7).map { o[rand(o.length)] }.join
	end

	def sanitize url
		url.strip!
		sanitized_url = url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
		sanitized_url.slice!(-1) if sanitized_url[-1] == "/"
		sanitized_url = "http://#{sanitized_url}"
	end
end