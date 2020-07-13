class UrlsController < ApplicationController
	protect_from_forgery with: :null_session

	def index
		@url = Url.new
	end

	def create
		uri = URI(permitted_params[:original_url])
		path_split = uri.path.split("/")
		
		if  path_split[-1] == "prices"
			@url = Url.find_or_create_by!(
				short_url: path_split[1]
				original_url: permitted_params[:original_url]
			)
		end

		@url = Url.find_by(original_url: permitted_params[:original_url]) ? Url.find_by(original_url: permitted_params[:original_url]) : Url.new(permitted_params)

		respond_to do |format|
			if @url.save
				format.json { 
					render json: { short_url: "#{request.base_url + '/' + @url.short_url}" }
				}
	   	else
	   	 	format.json { 
	   	 		render json: { short_url: "", error: "can't create" }
	   	 	}	
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