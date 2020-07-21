module Grape
  module Formatter
    module JsonapiSerializer
      class << self
        def call(object, env)
          return object if object.is_a?(String)
          return ::Grape::Json.dump(serialize(object, env)) if serializable?(object)
          return object.to_json if object.respond_to?(:to_json)
          ::Grape::Json.dump(object)
        end

        private

        def serializable?(object)
          return false if object.nil?

          object.respond_to?(:serializable_hash) || object.respond_to?(:to_a) && object.all? { |o| o.respond_to? :serializable_hash } || object.is_a?(Hash)
        end

        def serialize(object, env)
          if object.respond_to? :serializable_hash
            serializable_object(object, jsonapi_serializer_options(env)).serializable_hash
          elsif object.respond_to?(:to_a) && object.all? { |o| o.respond_to? :serializable_hash }
            serializable_collection(object, jsonapi_serializer_options(env))
          elsif object.is_a?(Hash)
            serialize_each_pair(object, env)
          else
            object
          end
        end

        def serializable_object(object, options)
          jsonapi_serializer_serializable(object, options) || object
        end

        def jsonapi_serializer_serializable(object, options)
          serializable_class(object, options)&.new(object, options)
        end

        def serializable_collection(collection, options)
          if heterogeneous_collection?(collection)
            data, meta, links, included = [], [], [], []
            collection.map do |o|
              serialized = (jsonapi_serializer_serializable(o, options).serializable_hash || o.map(&:serializable_hash))
              data << serialized[:data]
              meta = serialized[:meta]
              links = serialized[:links]
              included << serialized[:included]
            end
            { data: data, meta: meta, links: links, included: included.flatten }
          else
            jsonapi_serializer_serializable(collection, options)&.serializable_hash || collection.map(&:serializable_hash)
          end
        end

        def heterogeneous_collection?(collection)
          collection.map { |item| item.class.name }.uniq.size > 1
        end

        def serializable_class(object, options)
          klass_name = options['serializer'] || options[:serializer]
          klass_name ||= begin
            object = object.first if object.is_a?(Array)

            (object.try(:model_name) || object.class).name + 'Serializer'
          end

          klass_name&.safe_constantize
        end

        def serialize_each_pair(object, env)
          h = {}
          object.each_pair { |k, v| h[k] = serialize(v, env) }
          h
        end

        def jsonapi_serializer_options(env)
          env['jsonapi_serializer_options'] || {}
        end
      end
    end
  end
end
