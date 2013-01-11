class BlocksController < InheritedResources::Base
  respond_to :json
  #skip CSRF protection due to API
  skip_before_filter :verify_authenticity_token
  actions :destroy, :update
  load_and_authorize_resource only: [:destroy,:update]

  # Renders json (blocks and relations) for one admin page
  def master #TODO: rewrite in other action
    @blocks=Block.master_collection(params[:id]).find_all{ |block| can? :read, block }.to_a
    @relations=Relation.relations_collection(params[:id],@blocks).find_all{ |rel| can? :read, rel }.to_a
    fresh_when etag: [@blocks,@relations]
  end

  # Creates a model of the specified type
  def create
    @block=params[:block][:type].constantize.new params[:block]
    if @block.is_a? Game
      @block.parent=current_domain
      current_user.roles.create! access: :manage_roles, block: @block
    end
    authorize!(params[:action],@block)
    @block.save!
    respond_with(@block)
  end

end