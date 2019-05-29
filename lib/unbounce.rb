require 'bundler/setup'
require "unbounce/version"
require 'json'
require 'ostruct'
require 'rest-client'
require "base64"

module Unbounce
  class Api
    
    MAX_RESULT_LIMIT = '1000'

    def initialize(opts = {})
      api_version = opts[:api_version].nil? ? "application/vnd.unbounce.api.v0.4+json" : "application/vnd.unbounce.api.v#{opts[:api_version]}+json"
      @headers = {Accept: api_version}
      @url = opts[:api_url].nil? ? "https://api.unbounce.com" : opts[:api_url]
      @auth = 'Basic ' + Base64.encode64(opts[:key]).chomp  
      @account_id = opts[:account_id].to_s if opts[:account_id]  

      #  -H "Accept: application/vnd.unbounce.api.v0.4+json"
    end

    def set_account_id(opts = {})
      @account_id = opts[:account_id].to_s
    end    

    def parse_json(response)
      body = JSON.parse(response.to_str) if response.code == 200
      OpenStruct.new(code: response.code, body: body)
    end

    def set_params(opts = {})
      params = {}
      #Result params
      params[:path] = opts[:path] if opts[:path]
      params[:sort_order] = opts[:sort_order] if opts[:sort_order] && (opts[:sort_order] == "asc" || opts[:sort_order] == "desc") # asc, desc
      params[:count] = true if opts[:count] # When true, don't return the response's collection attribute.
      params[:include_sub_pages] = true if opts[:include_sub_pages] # When true, include sub page form fields in the response

      #Page params      
      params[:from] = opts[:from] if opts[:from] # Limit results to those created after from. Example: 2014-12-31T00:00:00.000Z
      params[:to] = opts[:to] if opts[:to] # Limit results to those created before to. Example: 2014-12-31T23:59:59.999Z
      params[:offset] = opts[:offset] if opts[:offset] # Omit the first offset number of results. Example: 3
      params[:limit] =  (opts[:limit] != nil && opts[:limit].to_i < MAX_RESULT_LIMIT.to_i && opts[:limit].to_i > 0 ) ? opts[:limit] : MAX_RESULT_LIMIT  # Only return limit number of results. Example: 100
      params[:with_stats] = opts[:with_stats] if opts[:with_stats] # When true, include page stats for the collection. 
      params[:role] = opts[:role] if opts[:role] # Restricts the scope of the returned pages. one of viewer, author
     
      return params
    end

    def get_responses(opts = {})
      params = set_params(opts)
      response = parse_json(RestClient.get(@url+params[:path], params: params,Authorization: @auth, headers: @headers)).body
                 
      # response = (opts[:data]) ? response[opts[:data]] : response 
      
      return response
    end

# Account 
    def get_accounts(opts = {})
      opts[:path] = "/accounts"       

      if opts[:account_id]
        opts[:path] = opts[:path] + "/#{opts[:account_id]}/pages"
      else
        # opts[:data] = "accounts"
      end

      return get_responses(opts)  
    end

# Pages
    def get_pages(opts = {})
      opts[:path] = "/pages"       

      if opts[:account_id]
        opts[:path] = "/accounts/#{opts[:account_id]}/pages"
      elsif opts[:page_id]
        opts[:path] = opts[:path] + "/#{opts[:page_id]}"
        opts[:path] = opts[:path] + "/form_fields" if opts[:form_fields] == true
      else
       # opts[:data] = "pages" 
      end    

      return get_responses(opts)  
    end

# Leads
  def get_leads(opts = {})

    if opts[:page_id]
      opts[:path] = "/pages/#{opts[:page_id]}/leads"
    #  opts[:data] = "leads"
    elsif opts[:lead_id]
      opts[:path] = "/leads/#{opts[:lead_id]}"
    end   

    return get_responses(opts)  
  end



  end
end
