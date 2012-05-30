class BlocksController < InheritedResources::Base
  respond_to :json
  #skip CSRF protection due to API
  skip_before_filter :verify_authenticity_token
  actions :destroy, :update

  # Renders json (blocks and relations) for one admin page
  def show
    @blocks=Block.master_collection(params[:id])
    @relations=Relation.relations_collection(params[:id],@blocks)
    #здесь не надо вводить кэширование, т.к. оно работает медленнее чем рендер в json
  end

  # Creates a model of the specified type
  def create
    respond_with(@block=params[:block][:type].constantize.create!(params[:block]))
  end

end