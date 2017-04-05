module RenderHelper

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => true, :status => :not_found }
      format.any  { head :not_found }
    end
  end

  # TODO - This is still not fixed.
  # May be it will work on Ajax Request and show sign in pop up.
  # This is not working for HTTP direct requests
  def handle_invalid_authenticity_token
    heading = I18n.t("status.invalid_token.heading")
    message = I18n.t("status.invalid_token.message")
    js_message = <<-eos
      showMessageModal('#{heading}','#{message}');
      notifyError('#{heading}','#{message}');
    eos
    respond_to do |format|
      format.html { 
        #redirect_to root_path
        render template: '/kuppayam/404', layout: 'kuppayam/blank', :status => 404
      }
      format.js { render text: js_message }
    end
  end

  def render_or_redirect(error, redirect_url, action, notice=nil)
    respond_to do |format|
      format.html {
        if error
          render action: action
        else
          redirect_to redirect_url, notice: notice
        end
      }
      format.js {
        view_path = @resource_options && @resource_options[:view_path] ? "#{@resource_options[:js_view_path]}/#{params[:action]}" : params[:action].to_s
        render view_path
      }
    end
  end

  def render_accordingly
    respond_to do |format|
      format.html { 
        get_collections
        render :index
      }
      format.js  { 
        view_path = @resource_options && @resource_options[:view_path] ? "#{@resource_options[:js_view_path]}/#{params[:action]}" : params[:action].to_sym
        render view_path
      }
    end
  end

  def render_show
    respond_to do |format|
      format.js { 
        js_view_path = @resource_options && @resource_options[:view_path] ? "#{@resource_options[:js_view_path]}/show" : :show
        render js_view_path
      }
    end
  end

  def render_row
    respond_to do |format|
      format.html {}
      format.js  { 
        js_view_path = @resource_options && @resource_options[:js_view_path] ? "#{@resource_options[:js_view_path]}/row" : :row 
        render js_view_path
      }
    end
  end
end