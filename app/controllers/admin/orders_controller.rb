class Admin::OrdersController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @orders = Order.search(search_params, {col: sort_column, dir: sort_direction})
        .paginate(per_page: 10, page: params[:page])

    @states = get_states
  end

  def show
    @order = Order.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = OrderPdf.new(@order, view_context)
        send_data pdf.render, filename: "order_#{@order.id}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.next_state
      flash[:success] = t('order_state_successfully_updated')
    else
      flash[:error] = t('error_order_state_successfully_updated')
    end

    render 'show'

  end

  private
    def search_params
      binds               = {}
      binds[:id]          = params[:id]          if params[:id]          && !params[:id].blank?
      binds[:state]       = params[:state]       if params[:state]       && !params[:state].blank?
      binds[:email]       = params[:email]       if params[:email]       && !params[:email].blank?
      binds[:customer_id] = params[:customer_id] if params[:customer_id] && !params[:customer_id].blank?
      binds[:date_from] = DateTime.parse(params[:date_from]) if params[:date_from]  && !params[:date_from].blank?
      binds[:date_to]   = DateTime.parse(params[:date_to])   if params[:date_to]    && !params[:date_to].blank?

      return binds
    end

    def get_states
       # Order.state_machine.states.map {|s| {id: s.name, value: Order.human_state_name(s.name)}}
       Order.state_machine.states.collect {|s| [ Order.human_state_name(s.name), s.name ] }
    end

    def sort_column
      %w(id email state purchased_at updated_at).include?(params[:sort].to_s) ? params[:sort] : "id"
    end

    def sort_direction
        %w(asc desc).include?(params[:direction].to_s) ? params[:direction] : "asc"
    end

end
