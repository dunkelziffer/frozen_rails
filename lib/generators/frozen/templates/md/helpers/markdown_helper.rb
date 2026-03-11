module MarkdownHelper

  def pages_image_tag(path)
    image_tag "pages/#{@page.slug}/#{path}"
  end

  def render_content_from(page)
    erb_processed_content = render(inline: page.content, layout: false)
    Kramdown::Document.new(
      erb_processed_content,
      input: "GFM",
      syntax_highlighter: :rouge
    ).to_html.html_safe
  end

end
