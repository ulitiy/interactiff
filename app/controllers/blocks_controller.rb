class BlocksController < InheritedResources::Base
  respond_to :json
  skip_before_filter :verify_authenticity_token #отключаем защиту от CSRF, т.к. API
  actions :destroy

  def show
    @blocks=Block.master_collection(params[:id])
    b=Block.find_by_id params[:id]
    @relations=[] and return if params[:id]=="0"# || !b.parent_game
    unless b.parent_game
      @relations=@blocks.reduce [] { |arr,b| arr+=b.out_relations }
      return
    end
    @relations=b.parent_game.relations
    #здесь не надо вводить кэширование, т.к. оно работает медленнее чем рендер в json
  end

  def create
    respond_with(params[:block][:type].constantize.create!(params[:block]))
  end

  def update
    respond_with(Block.find(params[:id]).update_attributes!(params[:block]))
  end

end