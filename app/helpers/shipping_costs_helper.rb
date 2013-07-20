module ShippingCostsHelper

  def shipping_costs_options(shipping_costs)
    shipping_costs.map do |sc|
      label_tag "shipping_cost_id_#{sc.id}", nil, :class => 'radio' do
        radio_button_tag("shipping_address[shipping_cost_id]", sc.id, nil ,:class => "shipping-costs-ops") +
        sc.shipping_method.name
      end
    end.join.html_safe
  end
end
