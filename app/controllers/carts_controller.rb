class CartsController < ApplicationController
  def show
    @order_items = current_order.order_items
    @total_price = @order_items.inject(0){|sum,x| sum + x.total_price}
  end
  def checkout

  end
  def payment
    total_amount = params[:total_amount_due]
    username = params[:username]
    number = params[:credit_card_number]
    expiry_month = params[:expiry_month]
    expiry_year = params[:expiry_year]
    cvv = params[:cvv]
    # Build Payment object
    @payment = PayPal::SDK::REST::Payment.new({
  :intent => "sale",
  :payer => {
    :payment_method => "credit_card",
    :funding_instruments => [{
      :credit_card => {
        :type => "visa",
        :number => "#{number}",
        :expire_month => "#{expiry_month}",
        :expire_year => "#{expiry_year}",
        :cvv2 => "#{cvv}",
        :first_name => "Joe",
        :last_name => "Shopper",
        :billing_address => {
          :line1 => "52 N Main ST",
          :city => "Johnstown",
          :state => "OH",
          :postal_code => "43210",
          :country_code => "US" }}}]},
  :transactions => [{
    :item_list => {
      :items => [{
        :name => "item",
        :sku => "item",
        :price => "#{total_amount}",
        :currency => "USD",
        :quantity => 1 }]},
    :amount => {
      :total => "#{total_amount}",
      :currency => "USD" },
    :description => "This is the payment transaction description." }]})
    # Create Payment and return the status(true or false)
      if @payment.create
      session[:payment_id] = @payment.id     # Payment Id
      flash[:notice] = "Payement #{ @payment.id} to cart."
      redirect_to invoice_cart_url
      else
      puts @payment.error  # Error Hash
      redirect_to cart_url
      end
  end

def invoice

  @payment = PayPal::SDK::REST::Payment.find(session[:payment_id])
  if @payment
    Cart.create(order_id: "#{@payment.id}",amount: "#{@payment.transactions.first.amount.details.subtotal}",status: "1",payment_date: "#{@payment.create_time}")
    reset_session
    flash[:notice] = "Payement Succes"
  else
    flash[:notice] = "Payement Failed"
    end
end

end
