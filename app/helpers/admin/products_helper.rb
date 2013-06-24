module Admin::ProductsHelper

  def product_row(product)
    content_tag(:tr,
      content_tag(:td, product.id) +
      content_tag(:td, product.code) +
      content_tag(:td, product.name) +
      content_tag(:td, product.category.name) +
      content_tag(:td, product.brand.name) +
      content_tag(:td, product.current_stock) +
      content_tag(:td, product.minimum_stock) +
      content_tag(:td,
        hidden_field_tag(:hideen_state, product.id, :id => "hidden-state-#{product.id}") +
        check_box_tag(:state, 1, product.active?,   :id => "state-#{product.id}")
      ) +
      content_tag(:td,
        link_to( t('edit'), edit_admin_product_path(product) ) + ' | ' +
        link_to( t('detail'), admin_product_path(product) )
      ),
      :class => row_class(product)
    ).html_safe
  end

  def picture_thumbnail(picture)
    content_tag(:div,
      image_tag(picture.image_url(:thumb), :alt => picture.imageable.name, :style => "width:50px;height:50px;" ) +
      content_tag(:div,
        content_tag(:p,
          link_to( t('remove'), [:admin, picture], :confirm => 'Are you sure?', :method => :delete,
            :class => 'btn btn-danger btn-mini'
          ),
          :style => 'text-align: center;'
        ),
        :class => 'caption'
      ),
      :class => "thumbnail"
    ).html_safe
  end

  private
    def row_class(product)
      if product.current_stock > product.highlight_stock_from
        return 'success'
      elsif product.current_stock == product.highlight_stock_from
        return 'info'
      elsif (product.current_stock < product.highlight_stock_from &&
            product.current_stock > product.minimum_stock)
        return 'warning'
      else
        return 'error'
      end
    end

end
