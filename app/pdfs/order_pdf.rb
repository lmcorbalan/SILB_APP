class OrderPdf < Prawn::Document
  def initialize(order, view)
    super(top_margin: 70)
    @order = order
    @view = view
    order_number
    billing_detail
    shipping_detail
    line_items
    total_price
  end

  def order_number
    text "#{I18n.t('order')} \##{@order.id}", size: 30, style: :bold
  end

  def billing_detail
    move_down 20
    text "<b><u>#{I18n.t('billing')}</u></b>", size: 16, inline_format: true
    move_down 5
    text "<b>#{I18n.t('billing_name')}:</b> #{@order.payment.last_name}, #{@order.payment.first_name}",
         size: 12,
         inline_format: true
  end

  def shipping_detail
    move_down 20
    text "<b><u>#{I18n.t('shipping')}</u></b>", size: 16, inline_format: true
    move_down 5
    text "<b>#{ShippingAddress.human_attribute_name("reference_name")}:</b> #{@order.shipping_address.reference_name}\n" +
         "<b>#{ShippingAddress.human_attribute_name("reference_last_name")}:</b> #{@order.shipping_address.reference_last_name}\n" +
         "<b>#{ShippingAddress.human_attribute_name("company_name")}:</b> #{@order.shipping_address.company_name}\n" +
         "<b>#{ShippingAddress.human_attribute_name("reference_phone")}:</b> #{@order.shipping_address.reference_phone}\n" +
         "<b>#{I18n.t('region')}:</b> #{@order.shipping_cost.city.region.name}\n" +
         "<b>#{I18n.t('city')}:</b> #{@order.shipping_cost.city.name}\n" +
         "<b>#{ShippingAddress.human_attribute_name("zip_code")}:</b> #{@order.shipping_address.zip_code}\n" +
         "<b>#{ShippingAddress.human_attribute_name("shipping_address_1")}:</b> #{@order.shipping_address.shipping_address_1}\n" +
         "<b>#{ShippingAddress.human_attribute_name("shipping_address_2")}:</b> #{@order.shipping_address.shipping_address_2}" ,
         size: 12,
         inline_format: true
  end

  def line_items
    move_down 20
    text "<b><u>#{I18n.t('order_detail')}</u></b>", size: 16, inline_format: true
    move_down 5
    table line_item_rows do
      row(0).font_style = :bold
      columns(3).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_item_rows
    [[
      LineItem.human_attribute_name("quantity"),
      Product.human_attribute_name("code"),
      Product.human_attribute_name("name"),
      LineItem.human_attribute_name("unit_price_cent")
    ]] +
    @order.items.map do |item|
      [
        item.quantity,
        item.product.code,
        item.product.name,
        @view.humanized_money_with_symbol(item.unit_price)
      ]
    end +
    [[
      "--",
      "--",
      I18n.t('shipping_cost'),
      @view.humanized_money_with_symbol(@order.shipping_cost.price)
    ]]
  end

  def total_price
    move_down 10
    text "<b><u>#{I18n.t('total')}</u></b>", size: 16, inline_format: true
    move_down 5
    text "#{I18n.t('ar_total')}: #{@view.humanized_money_with_symbol(@order.total)}", size: 12, style: :bold
  end
end
