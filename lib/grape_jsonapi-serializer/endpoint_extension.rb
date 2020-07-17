module Grape
  module EndpointExtension
    def render(resources, options = {})
      env['jsonapi_serializer_options'] = options
      resources
    end
  end

  Endpoint.send(:include, EndpointExtension)
end
