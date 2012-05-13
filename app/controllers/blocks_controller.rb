class BlocksController < InheritedResources::Base
  respond_to :json
  skip_before_filter :verify_authenticity_token #отключаем защиту от CSRF, т.к. API
  actions :destroy

  def show
    @blocks=Block.master_collection(params[:id])
    @relations=Relation.relations_collection(@blocks,params[:id])
    #здесь не надо вводить кэширование, т.к. оно работает медленнее чем рендер в json
  end

  def create
    respond_with(params[:block][:type].constantize.create!(params[:block]))
  end

  def update
    b=Block.find(params[:id])
    b.update_attributes(params[:block])
    respond_with b
  end

end