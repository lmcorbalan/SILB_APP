module Admin::CategoriesHelper

  def tree_view(categories)
    categories.map do |category, sub_categories|
      if !sub_categories.blank?
        content_tag(:li,
          content_tag(:span,
            content_tag(:i,'', :class => category.root? ? "icon-folder-open" : "icon-minus-sign") +
              category.name,
            :title => t("collapse")
          )  +
          links(category) +
          content_tag(:ul, tree_view(sub_categories)),
          :class => "parent_li"
        )
      else
        content_tag(:li,
          content_tag(:span,
            content_tag(:i,'', :class => category.root? ? "icon-folder-open" : "icon-leaf") +
            category.name
          ) + links(category)
        )
      end
    end.join.html_safe
  end

  private
    def links(category)
      link_to_edit(category) + " | " + link_to_remove(category)
    end

    def link_to_edit(category)
      link_to( t("edit"), edit_admin_category_path(category) )
    end

    def link_to_remove(category)
      link_to( t('remove'), [:admin, category],
        confirm: t('are_you_sure_you_want_to_delete_the_category?', :category => category.name),
        method: :delete )
    end

end
