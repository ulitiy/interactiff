# API blocks controller for an author. Can manage all the blocks.
class BlocksController < InheritedResources::Base
  respond_to :json
  #skip CSRF protection due to API
  skip_before_filter :verify_authenticity_token
  actions :destroy, :update
  load_and_authorize_resource only: [:destroy,:update]

  # Renders json (blocks and relations) for one admin page
  def master #TODO: rewrite in other action
    @blocks=Block.master_collection(params[:id]).find_all{ |block| can? :show, block }.to_a
    @relations=Relation.relations_collection(params[:id],@blocks).find_all{ |rel| can? :show, rel }.to_a
    fresh_when etag: [@blocks,@relations]
  end

  # Creates a model of the specified type
  # TODO: Перенести логику с ролями в модель
  def create
    not_found unless params[:block][:type].in? Block.descendants.map &:to_s
    @block=params[:block][:type].constantize.new params[:block]
    if @block.is_a? Game
      @block.parent=current_domain
      current_user.engine_roles.create! access: :manage_roles, block: @block
    end
    authorize!(:create,@block)
    @block.save!
    respond_with(@block)
  end

end
