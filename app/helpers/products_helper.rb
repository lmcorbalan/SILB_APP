module ProductsHelper

  def product_carousel(product)
    ol = -1
    im = -1
    content_tag(:div,
      content_tag(:ol,
        product.brand.pictures.map do |picture|
          content_tag(:li, nil, :'data-target' => "#myCarousel", :'data-slide-to' => (ol+=1), :class => ol == 0 ? "active" : "")
        end.join.html_safe +
        product.pictures.map do |picture|
          content_tag(:li, nil, :'data-target' => "#myCarousel", :'data-slide-to' => (ol+=1), :class => ol == 0 ? "active" : "")
        end.join.html_safe,
        :class => "carousel-indicators"
      ) +
      content_tag(:div,
        product.brand.pictures.map do |picture|
          content_tag(:div,
            nil,
            :style =>  "background:url(#{picture.image_url(:detail)}) center center no-repeat;",
            :class => "item #{'active' if (im+=1) == 0}"
          )
        end.join.html_safe +
        product.pictures.map do |picture|
          content_tag(:div,
            nil,
            :style =>  "background:url(#{picture.image_url(:detail)}) center center no-repeat;",
            :class => "item #{'active' if (im+=1) == 0}"
          )
        end.join.html_safe,
        :class => "carousel-inner"
      ) +
      link_to( "&lsaquo;".html_safe, "#myCarousel", :class => "carousel-control left", :'data-slide' => "prev") +
      link_to( "&rsaquo;".html_safe, "#myCarousel", :class => "carousel-control right", :'data-slide' => "next"),
      :class => "carousel slide", :id => "myCarousel"
    ).html_safe
  end

end
