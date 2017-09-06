module RenderApiHelper
  def embed_stack_in_json_response?
    return true if Rails.env.development?
    Rails.env.production? && ["true", "t", "1", "yes"].include?(params[:debug].to_s.downcase.strip)
  end

  ## This method will accept a proc, execute it and render the json
  def render_json_response(proc_code)

    begin
      proc_code.call
      @success = @success == false ? (false) : (true)
    rescue Exception => e
      @success = false
      @errors = { 
                  heading: I18n.translate("api.general.unexpected_failure.heading"),
                  message: I18n.translate("api.general.unexpected_failure.message"),
                  details: e.message,
                  stacktrace: (embed_stack_in_json_response? ? e.backtrace : nil)
                }
    end
    @status ||= 200

    response_hash = {success: @success}
    response_hash[:alert] = @alert unless @alert.blank?
    response_hash[:data] = @data unless @data.blank?
    response_hash[:errors] = @errors unless @errors.blank?
    
    response_hash[:total_data] = @total_data unless @total_data.blank?
    response_hash[:per_page] = @per_page unless @per_page.blank?
    response_hash[:current_page] = @current_page unless @current_page.blank?

    render status: @status, json: response_hash
    return
  end

  private

  def breadcrumbs_configuration
    {
      heading: "Usman - API Documentation",
      description: "A brief documentation of all APIs implemented in the gem Usman with input and output details and examples",
      links: []
    }
  end
end