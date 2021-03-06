# -*- encoding : utf-8 -*-
class Admin::MediaSetsController < Admin::AdminController
  
  before_filter do
    unless (params[:media_set_id] ||= params[:id]).blank?
      @set = MediaSet.find(params[:media_set_id])
    end
  end

#####################################################

  def index
    @sets = MediaSet.all
  end

  def new
    @set = MediaSet.new
    respond_to do |format|
      format.js
    end
  end

  def create
    type = params[:media_set].delete(:type)
    set = MediaSet.create(:user => current_user)
    set.update_attributes(params[:media_set])
    redirect_to admin_media_sets_path
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if params[:individual_contexts] and @set.respond_to? :individual_contexts
      @set.individual_contexts = MetaContext.find(params[:individual_contexts])
    end
    
    @set.update_attributes(params[:media_set])

    redirect_to admin_media_sets_path
  end

  def destroy
    @set.destroy if @set.child_media_resources.media_entries.empty?
    redirect_to admin_media_sets_path
  end

#####################################################

  def special
    if request.post?
      AppSettings.catalog_set_id = params[:catalog_set_id].to_i
      AppSettings.featured_set_id = params[:featured_set_id].to_i
      AppSettings.splashscreen_slideshow_set_id = params[:splashscreen_slideshow_set_id].to_i
      redirect_to special_admin_media_sets_path
    else
      @media_sets = MediaSet.where(:view => true)
    end
  end
  
end
