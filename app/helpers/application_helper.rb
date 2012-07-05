# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    require 'string'
    # navi menu
    def nav_link(text, controller, action="index")
        link_to_unless_current text, :controller => controller, :action => action
    end
    
    def logged_in?
        not session[:user_id].nil?
    end
    
    def text_field_for(form, field, model, size=HTML_TEXT_FIELD_SIZE, maxlength=DB_STRING_MAX_LENGTH)
        label = content_tag("label", "#{model.human_attribute_name(field.to_str)}", :for => field)
        form_field = form.text_field field, :size => size, :maxlength => maxlength
        content_tag("div", "#{label} #{form_field}", :class => "form_row")
    end
end
