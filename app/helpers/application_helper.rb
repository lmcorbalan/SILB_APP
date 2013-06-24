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

  def sortable(colum, title = nil)

    title ||= colum.titleize
    direction = colum == sort_column && sort_direction == "asc" ? "desc" : "asc"
    icon = direction == "asc" ? "icon-arrow-up" : "icon-arrow-down"
    span = colum == sort_column ? content_tag(:span, nil ,:class => icon) : ''

    link_to (title + span ).html_safe, params.merge(sort: colum, direction: direction, page: nil)
  end

  def nested_menu(categories)
    categories.map do |category, sub_categories|
      if !sub_categories.blank?
        content_tag(:li,
          link_to(category.name, '#') +
          content_tag(:ul, nested_menu(sub_categories),:class => "dropdown-menu"),
          :class => "dropdown-submenu"
        )
      else
        content_tag(:li, link_to(category.name, '#'))
      end
    end.join.html_safe
  end

end
