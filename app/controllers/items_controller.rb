class ItemsController < ApplicationController
  include ActionView::RecordIdentifier
  
  def index
    @sort = params[:sort].to_i

    if @sort == 1
      @pagy, @items = pagy(Item.all.order(cached_votes_total: :desc))
      #  do |item|
      #     render turbo_stream: turbo_stream.prepend("items", target: "items_list", partial: "items/itemnew", locals: {item: item})
      # end
    else
      @pagy, @items = pagy(Item.all.order(id: :desc))
      # do |item|
      #   render turbo_stream: turbo_stream.prepend("items", target: "items_list", partial: "items/itemnew", locals: {item: item})
      # end
    end
    @sort = 1 - @sort
  end

  def vote
    @item = Item.find(params[:id])
    
    if current_user.voted_for? @item
      @item.unliked_by current_user
    else
      @item.liked_by current_user
    end

    @item.broadcast_replace_to "items", partial: "items/itemvote", locals: { item: @item }, target: dom_id(@item)
    head :no_content
  end

  def refeed
    @msg = refresh_news

    if @msg[0] == ' '
      Turbo::StreamsChannel.broadcast_replace_to "status", partial: "partials/notice", locals: { notice: @msg }, target: 'notice'
    else
      Turbo::StreamsChannel.broadcast_replace_to "status", partial: "partials/alert", locals: { alert: @msg }, target: 'alert'
    end

    head :no_content
  end

  private

  def refresh_news
    NewsClient.new.news_update
  end
end
