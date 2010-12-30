module Rack
  class MogileFS
    class Endpoint

      # This contains the base functionality for serving a MogileFS file. Most
      # of the useful stuff is layered on top the base class in other modules
      module Base
        def initialize(options={})
          @options = {
            :default_content_type => "image/png"
          }.merge(options)
        end

        def call(env)
          path = key_for_path( env['PATH_INFO'].dup )
          serve_file(path)
        end

        protected

        def serve_file(path)
          data = client.get_file_data(path)
          size = Utils.bytesize(data).to_s

          [ 200, headers(path, data), [data] ]
        end

        def client
          @options[:client]
        end

        def key_for_path(path)
          path
        end

        def headers(path, data)
          {
            "Content-Type"   => content_type(path),
            "Content-Length" => content_length(data)
          }
        end

        def content_type(path)
          Mime.mime_type(::File.extname(path), @options[:default_content_type])
        end

        def content_length(data)
          Utils.bytesize(data).to_s
        end

      end

    end
  end
end
