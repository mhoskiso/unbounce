# unbounce

Simple GEM to access the Unbounce API. (https://unbounce.com/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unbounce'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unbounce

## Usage

### Setting Connection

###### Required value
* key: Your Unbounce API key.
###### Optional 
* api_url: 
    Defaults to https://api.unbounce.com
* api_version: 
    Defaults to 0.4

```ruby
opts = {key: "<Your unbounce API Key>"}
testcon = Unbounce::Api.new(:key => opts[:key]) 
```

### Query Parameters

###### sort_order 
* asc - Default
* desc
###### count
When true, don't return the response's collection attribute.
###### from
Limit results to those created after from. Example: 2014-12-31T00:00:00.000Z
###### to
Limit results to those created before to. Example: 2014-12-31T23:59:59.999Z
###### offset
Omit the first offset number of results. Example: 3
###### limit
Only return limit number of results. Example: 100, Default set to Maximum of 1000
###### with_stats
When true, include page stats for the collection. 
###### role
Restricts the scope of the returned pages. one of viewer, author
###### include_sub_pages
When true, include sub page form fields in the response

### Get Accounts
Retrieve the accounts collection.

Supported Params: 
* sort_order

```ruby
testcon.get_accounts 
```

### Get Pages
###### All Pages
Retrieve a list of all pages. 

Supported Params: 
* sort_order
* count
* from
* to
* offset
* limit
* with_stats
* role

```ruby
testcon.get_pages() 
```
###### All Pages for specific account
```ruby
 opts = {account_id:  <account_id>}
 testcon.get_pages(opts) 
 ```
###### Specific page
```ruby
opts = {page_id:  <page_id>}
testcon.get_pages(opts) 
```
###### Page Form Fields
Retrieve a full list of all form fields across all page variants of a specific page.

Supported Params: 
* sort_order
* count
* include_sub_pages

```ruby
opts = {page_id:  <page_id>, form_fields: true}
testcon.get_pages(opts) 
```

### Get Leads
###### All for page
Retrieve a list of all leads for a given page.

Supported Params: 
* sort_order
* count
* from
* to
* offset
* limit

```ruby
opts = {page_id:  <page_id>}
testcon.get_leads(opts) 
```
###### Single Lead
Retrieve a single lead.

```ruby
opts = {lead_id:  <lead_id>}
testcon.get_leads(opts) 
```


## Version History
# v0.1.0
Initial work for retrieving accounts, pages, and leads.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mhoskiso/unbounce. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Unbounce project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mhoskiso/unbounce/blob/master/CODE_OF_CONDUCT.md).
