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

### Model parser for response documentation

When using Grape with Swagger via [grape-swagger](https://github.com/ruby-grape/grape-swagger), you can generate response documentation automatically via the provided following model parser:

```ruby
# Jsonapi Serializer example

# app/serializers/base_serializer.rb
class BaseSerializer; end
# app/serializers/user_serializer.rb
class UserSerializer < BaseSerializer
  include JSONAPI::Serializer

  set_type :user
  has_many :orders

  attributes :name, :email
end

# config/initializers/grape_swagger.rb
GrapeSwagger.model_parsers.register(GrapeSwagger::JsonapiSerializer::Parser, BaseSerializer)

# Your grape API endpoint
desc 'Get current user' do
  success code: 200, model: UserSerializer, message: 'The current user'
# [...]
end
```

## Credit

Code adapted from [Grape::FastJsonapi](https://github.com/EmCousin/grape_fast_jsonapi)
