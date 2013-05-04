module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "SILB"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def section_title(title)
    if !title.empty?
        "<div class='page-header'>
            <h1 class='center'>#{title}</h1>
        </div>".html_safe
    end
  end
end
