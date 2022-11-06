module Jekyll
    class DocsByPathGenerator < Jekyll::Generator
      safe true
  
      def generate(site)
        @docs_by_path = Hash.new
        @site = site
  
        @site.data["navigation"].keys.each do |lang|
          @site.data["navigation"][lang]["menu"].each do |collection|
            next unless collection.key? "content"
            collection["content"].each do |category|
              docs(lang, category, collection["meta"]["ref"])
              if category.key? "sub-content"
                category["sub-content"].each do |sub_category|
                  docs(lang, sub_category, collection["meta"]["ref"])
                end
              end
            end
          end
        end
  
        @site.config["docs_by_path"] = @docs_by_path
      end
  
      private
  
      def docs(lang, category, collection)
        if category.key? "docs"
          category["docs"].each do |doc|
            add_path("_#{lang}/#{collection}/#{doc}")
          end
        end
      end
  
      def add_path(full_path)
        doc = @site.documents.find { |d|  d.relative_path == full_path }
        @docs_by_path[full_path] = [
          doc.url,
          doc.data["title"],
          doc.content,
          (doc.data.key?("product_label") ? doc.data["product_label"] : []),
          (doc.data.key?("description") ? doc.data["description"] : (doc.content[0..160] + "..."))
        ] unless doc.nil?
      end
    end
  end