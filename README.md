# Grape::JsonapiSerializer

Use [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer) with [Grape](https://github.com/ruby-grape/grape).

## Installation

Add the `grape` and `grape_jsonapi-serializer` gems to Gemfile.

```ruby
gem 'grape'
gem 'grape_jsonapi-serializer'
```
## Usage

### Tell your API to use Grape::Formatter::JsonapiSerializer

```ruby
class API < Grape::API
  content_type :jsonapi, "application/vnd.api+json"
  formatter :json, Grape::Formatter::JsonapiSerializer
  formatter :jsonapi, Grape::Formatter::JsonapiSerializer
end
```

### Use `render` to specify JSONAPI options

```ruby
get "/" do
  user = User.find("123")
  render user, include: [:account]
end
```

### Use a custom serializer

```ruby
get "/" do
  user = User.find("123")
  render user, serializer: 'CustomUserSerializer'
end
```

Or

```ruby
get "/" do
  user = User.find("123")
  render CustomUserSerializer.new(user).serialized_json
end
```

## Credit

Code adapted from [Grape::FastJsonapi](https://github.com/EmCousin/grape_fast_jsonapi)
