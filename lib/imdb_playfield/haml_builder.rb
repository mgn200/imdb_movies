module ImdbPlayfield
  # Creates an index.html file based on movies data.
  class HamlBuilder
    HTML_FILE = "index.html"
    # Splits array of movies into array of arrays with two movies in each.
    # Each subarray represents bootstrap rows in html template.
    # Also sets gem bootstrap varibales that are used in html template.
    # @param movies_array [Array<AncientMovie, ModernMovie, NewMovie, ClassicMovie>] array of movies
    # @return [HamlBuilder] object
    def initialize(movies_array = ImdbPlayfield::MovieCollection.new)
       @bootstrap_js = File.join(File.dirname(File.expand_path("../../", __FILE__)), 'data/views/js/bootstrap.min.js')
       @bootstrap_css = File.join(File.dirname(File.expand_path("../../", __FILE__)), 'data/views/css/bootstrap.min.css')
       @movies_row = movies_array.each_slice(2).to_a
    end

    # Creates index.html in the current folder from @movies_row array. @movies_row is created in {HamlBuilder#initialize}.
    # @return [Boolean] true when creates index.html file
    def build_html
      rendered_template = Haml::Engine.new(haml_layout).render(self)
      File.write(HTML_FILE, rendered_template)
      return true
    end

    # Content of haml layout file stored in String. Used for rendering html file with movie content.
    # @return [String] contents of index.haml
    # @see HamlBuilder#build_html
    def haml_layout
      file = File.join(File.dirname(File.expand_path("../../", __FILE__)), 'data/views/index.haml')
      File.read file
    end
  end
end
