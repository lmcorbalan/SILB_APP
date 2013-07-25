class Admin::ReportsController < Admin::BaseController

  def sales_report
    @sales_data = Order.sales_report_data(date_from, date_to)
    logger.debug { "sales_data => #{@sales_data}" }
  end

  private
    def date_from
      params.has_key?(:date_from) && !params[:date_from].blank? ? Date.parse(params[:date_from]) : 3.weeks.ago
    end

    def date_to
      params.has_key?(:date_to) && !params[:date_to].blank? ? Date.parse(params[:date_to]) : Date.today
    end
end
