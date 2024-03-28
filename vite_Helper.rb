module ViteRails::TagHelpers
    def vite_javascript_tag(*names,
        type: 'module',
        asset_type: :javascript,
        skip_preload_tags: false,
        skip_style_tags: false,
        crossorigin: 'anonymous',
        media: 'screen',
        **options)

        # Extract query parameter
        query_param = request.query_parameters[:version]

        # If query parameter exists, construct entrypoint path
        if query_param.present?
        entrypoint_path = "v#{query_param}/vite"
        entries = vite_manifest.resolve_entries([entrypoint_path], type: asset_type)
        else
        # Fallback to original behavior
        entries = vite_javascript_tag(*names, type: asset_type, **options)
        end

        tags = javascript_include_tag(*entries.fetch(:scripts), crossorigin: crossorigin, type: type, extname: false, **options)
        tags << vite_preload_tag(*entries.fetch(:imports), crossorigin: crossorigin, **options) unless skip_preload_tags

        options[:extname] = false if Rails::VERSION::MAJOR >= 7

        tags << stylesheet_link_tag(*entries.fetch(:stylesheets), media: media, **options) unless skip_style_tags

        tags
    end
end
  
