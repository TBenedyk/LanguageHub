class Lookup
  
	attr_accessor :username

	require "net/https"

	API_ROOT = "https://api.github.com"

	# The language method gets the public repos for the user and loops through each one to find the hash of
	# languages used in the repo along with its data in bytes e.g. { "Ruby" => 17420, "JavaScript" => 641 }.
	# Each hash is then merged and sorted by the highest amount of bytes, returning the dominant overall language.

	# Lookup.language("username")
	
	def self.language(username)
		github_user = Lookup.new
		github_user.username = username
		languages_returned = Hash.new

		repos = github_user.get_repos

		repos.each do |repo|
			begin
				repo_languages = github_user.get_languages(repo["name"])
			rescue
				return "Github user cannot be found :("
			end
			languages_returned.merge!(repo_languages) { |key, old_value, new_value| old_value + new_value }
		end
		
		language_sorted = languages_returned.sort_by {|key, value| value}.reverse

		begin
			puts language_sorted
			language = language_sorted.first[0]
		rescue
			return "No languages detected :("
		end
	end

	def get_languages(repo)
		uri = URI.parse("#{API_ROOT}/repos/#{self.username}/#{repo}/languages")
		languages = self.get(uri)
	end

	def get_repos
		uri = URI.parse("#{API_ROOT}/users/#{self.username}/repos")
		repos = self.get(uri)
	end

	def get(uri)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request)
		repos = JSON.parse(response.body) # Parse JSON into Ruby object
	end

end