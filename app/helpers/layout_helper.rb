# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:stylesheets) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:javascripts) { javascript_include_tag(*args) }
  end

  def breadcrumb(crumbs, separator = "/")
    crumbs.each do |crumb|
      @html = '' unless defined?(@html)
      @html << (@html.empty? ? crumb : " #{separator} #{crumb}")
    end
    @html
  end

  def sidemenu(section='administrations')
    content_for :sidemenu do
      render "shared/#{section}"
    end
  end

  def hint(block)
    content_for :hint do
      render "shared/hint", :hint => block
    end
  end
end
