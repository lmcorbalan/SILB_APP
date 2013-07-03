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
          link_to( category.name.titleize(), catalogs_path( category: category.id) ) +
          content_tag(:ul, nested_menu(sub_categories),:class => "dropdown-menu"),
          :class => "dropdown-submenu"
        )
      else
        content_tag(:li, link_to( category.name.titleize, catalogs_path( category: category.id) ) )
      end
    end.join.html_safe
  end

  def admin_picture_upload(object)
    form_for [:admin, object.pictures.build], :html => { :multipart => true, :id => "fileupload"  } do |f|
      f.hidden_field(:imageable_id, :name => "#{object.class.name.underscore}_id") +
      content_tag(:div,
        content_tag(:div,
          content_tag(:span,
            content_tag(:i,nil,:class => "icon-plus icon-white") +
            content_tag(:span,t('add')) +
            f.file_field(:image),
            :class => "btn btn-success fileinput-button") +
          button_tag(type: 'submit', :class =>"btn btn-primary start") do
            content_tag(:i,nil,:class => "icon-upload icon-white") +
            content_tag(:span, ' '+ t('start'))
          end + ' ' +
          button_tag(type: 'reset', :class =>"btn btn-warning cancel") do
            content_tag(:i,nil,:class => "icon-ban-circle icon-white") +
            content_tag(:span, ' '+ t('cancel'))
          end + ' ' +
          button_tag(type: 'button', :class =>"btn btn-danger delete") do
            content_tag(:i,nil,:class => "icon-trash icon-white") +
            content_tag(:span, ' '+ t('remove'))
          end + ' ' +
          check_box_tag(nil,nil,false,:class => "toggle"),
          :class => "span7"
        ) +
        content_tag(:div,
          content_tag(:div,
            content_tag(:div, nil, :class => "bar", :style => "width:0%;"),
            :class => "progress progress-success progress-striped active fade"
          ),
          :class => "span5"
        ),
        :class => "row fileupload-buttonbar"
      ) +
      content_tag(:div, nil, :class => "fileupload-loading") + content_tag(:br) +
      content_tag(:table,
        content_tag(:tbody,
          nil,
          :class => "files", :'data-toggle' => "modal-gallery", :'data-target' => "#modal-gallery"
        ),
        :class => "table table-striped"
      ) +
      javascript_tag(
        "var fileUploadErrors = {
          maxFileSize: '#{t('file_is_too_big')}',
          minFileSize: '#{t('file_is_too_small')}',
          acceptFileTypes: '#{t('filetype_not_allowed')}',
          maxNumberOfFiles: '#{t('max_number_of_files_exceeded')}',
          uploadedBytes: 'Uploaded bytes exceed file size',
          emptyResult: 'Empty file upload result'
        };"
      ) +

      javascript_tag(
        "
    $(function () {
        // Initialize the jQuery File Upload widget:
        $('#fileupload').fileupload();
        //
        // Load existing files:
        var data = $('#picture_imageable_id').serialize();
        $.getJSON($('#fileupload').prop('action'), data, function (files) {
          var fu = $('#fileupload').data('blueimp-fileupload'),
            template;
          fu._adjustMaxNumberOfFiles(-files.length);
          template = fu._renderDownload(files)
            .appendTo($('#fileupload .files'));
          // Force reflow:
          fu._reflow = fu._transition && template.length &&
            template[0].offsetWidth;
          template.addClass('in');
          $('#loading').remove();
        });

    });
        "
      )


    end
  end

end
