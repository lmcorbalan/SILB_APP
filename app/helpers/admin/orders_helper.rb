module Admin::OrdersHelper

  def order_row(order)
    content_tag(:tr,
      content_tag(:td, order.id) +
      content_tag(:td, order.user.email) +
      content_tag(:td, order.human_state_name) +
      content_tag(:td, !order.purchased_at.blank? ? l(order.purchased_at.to_date, format: :default) : '' ) +
      content_tag(:td, l(order.updated_at.to_date, format: :default) ) +
      content_tag(:td, link_to( t('detail'), admin_order_path(order) ) )
    ).html_safe
  end

end
